import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () async {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr is AuthLoginSuccessState || curr is AuthUnauthenticated,

      listener: (context, state) {
        if (state is AuthLoginSuccessState) {
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
