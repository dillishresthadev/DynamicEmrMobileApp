import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/notification/notification_init.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NotificationRemoteDatasourceImpl.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () async {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      });
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
          // sending FCM token when user press login
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset('assets/logo/logo.jpeg'),
            ),
          ),
        ),
      ),
    );
  }
}
