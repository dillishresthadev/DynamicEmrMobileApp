import 'package:dynamic_emr/core/routes/app_routes.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/edge_to_edge.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/holiday/presentation/bloc/holiday_bloc.dart';
import 'package:dynamic_emr/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:dynamic_emr/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/punch/presentation/bloc/punch_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
import 'package:dynamic_emr/firebase_options.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Edge-to-edge design on Android
  EdgeToEdge.configure(
    statusBarColor: Colors.transparent,
    navigationBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark,
    navigationBarIconBrightness: Brightness.dark,
    enableTop: true,
    enableBottom: false,
  );
  // Initializing firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dependency Injection
  await initDependencies();

  // Bloc observer
  // Bloc.observer = MyBlocObserver();

  //Analytics
  if (kReleaseMode) {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    // crashlytics
    // flutter crashes
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // native crashes
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };
  } else {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => injection<AuthBloc>()),
        BlocProvider<ProfileBloc>(
          create: (context) => injection<ProfileBloc>(),
        ),
        BlocProvider(create: (context) => injection<AttendanceBloc>()),
        BlocProvider(create: (context) => injection<LeaveBloc>()),
        BlocProvider(create: (context) => injection<WorkBloc>()),
        BlocProvider(create: (context) => injection<PayrollBloc>()),
        BlocProvider(create: (context) => injection<NoticeBloc>()),
        BlocProvider(create: (context) => injection<HolidayBloc>()),
        BlocProvider(create: (context) => injection<PunchBloc>()),
        BlocProvider(create: (context) => injection<NotificationBloc>()),
      ],
      child: MaterialApp(
        title: 'Dynamic EMR',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: RouteNames.splashScreen,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
