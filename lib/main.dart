import 'package:dynamic_emr/core/routes/app_routes.dart';
import 'package:dynamic_emr/core/routes/route_names.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/holiday/presentation/bloc/holiday_bloc.dart';
import 'package:dynamic_emr/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/punch/presentation/bloc/punch_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
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
