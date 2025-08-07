import 'package:dynamic_emr/core/routes/app_routes.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => injection<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Dynamic EMR',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
