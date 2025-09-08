import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/notification/notification_init.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    NotificationRemoteDatasourceImpl.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), () async {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      });
    });
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "v${info.version}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationInitializer = NotificationInitializer(injection());

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr is AuthLoginSuccessState || curr is AuthUnauthenticated,
      listener: (context, state) async {
        if (state is AuthLoginSuccessState) {
          final code = await injection<ISecureStorage>().getHospitalCode();
          await notificationInitializer.initFCM(applicationId: code);
          Navigator.pushReplacementNamed(context, RouteNames.appMainNav);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.hospitalCodeScreen,
          );
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
