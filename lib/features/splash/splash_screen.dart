import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/core/notification/notification_init.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:dynamic_emr/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _appVersion = "";
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    NotificationRemoteDatasourceImpl.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () async {
        await _handleNavigation();
      });
    });
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "v${info.version}";
    });
  }

  Future<void> _handleNavigation() async {
    if (_navigated) return;

    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted =
        prefs.getBool('hospital_code_set') ?? false;

    if (!onboardingCompleted) {
      // First-time user → show hospital code screen (onboarding)
      _navigate(RouteNames.hospitalCodeScreen);
      return;
    }

    // Hospital code exists, continue with auth check
    final hospitalCode = await HospitalCodeStorage(
      const FlutterSecureStorage(),
    ).getHospitalCode();

    if (hospitalCode == null || hospitalCode.isEmpty) {
      // Somehow hospital code is missing → fallback to onboarding
      _navigate(RouteNames.hospitalCodeScreen);
      return;
    }

    // Listen for Auth state
    final authBloc = context.read<AuthBloc>();
    final subscription = authBloc.stream.listen((state) async {
      if (_navigated) return;

      final notificationInitializer = NotificationInitializer(injection());

      if (state is AuthLoginSuccessState) {
        await notificationInitializer.initFCM(applicationId: hospitalCode);
        _navigate(RouteNames.appMainNav);
      } else if (state is AuthUnauthenticated) {
        _navigate(RouteNames.loginScreen);
      }
    });

    authBloc.add(CheckAuthStatusEvent());

    Future.delayed(const Duration(seconds: 3), () {
      subscription.cancel();
    });
  }

  void _navigate(String routeName) {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset('assets/logo/logo.jpeg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _appVersion,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
