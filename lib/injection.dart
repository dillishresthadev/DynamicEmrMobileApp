import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/connectivity_check.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/Leave/data/datasource/leave_remote_datasource.dart';
import 'package:dynamic_emr/features/Leave/data/repository/leave_repository_impl.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/apply_leave_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/approved_leave_list_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/extended_leave_type_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_application_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_type_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/pending_leave_list_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/substitution_leave_employee_usecase.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/attendance/data/datasource/attendance_remote_datasource.dart';
import 'package:dynamic_emr/features/attendance/data/repository/attendance_repository_impl.dart';
import 'package:dynamic_emr/features/attendance/domain/repository/attendance_repository.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/attendance_summary_usecase.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/current_month_attendance_extended_usecase.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/current_month_attendance_primary_usecase.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:dynamic_emr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_branch_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_user_financial_year_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/profile/data/datasources/employee_remote_datasource.dart';
import 'package:dynamic_emr/features/profile/data/repository/employee_repository_impl.dart';
import 'package:dynamic_emr/features/profile/domain/repository/employee_repository.dart';
import 'package:dynamic_emr/features/profile/domain/usecases/employee_details_usecase.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final injection = GetIt.instance;

Future<void> initDependencies() async {
  // External dependencies
  // final sharedPreferences = await SharedPreferences.getInstance();
  // injection.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core
  injection.registerLazySingleton<Dio>(() => Dio());
  injection.registerLazySingleton(() => DioHttpClient(injection<Dio>()));
  injection.registerLazySingleton<ConnectivityCheck>(
    () => ConnectivityCheckImpl(connectivity: Connectivity()),
  );
  // Storage (Local Storage)
  injection.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  injection.registerLazySingleton<ISecureStorage>(
    () => HospitalCodeStorage(injection<FlutterSecureStorage>()),
  );
  // Token storage (access and refresh token)
  injection.registerLazySingleton<TokenSecureStorage>(
    () => TokenStorage(injection<FlutterSecureStorage>()),
  );
  // Branch storage (branch Id,financial year Id)
  injection.registerLazySingleton<BranchSecureStorage>(
    () => BranchStorage(injection<FlutterSecureStorage>()),
  );

  // Auth (user login)

  injection.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUsecase: injection<LoginUsecase>(),
      hospitalBaseUrlUsecase: injection<FetchHospitalBaseUrlUsecase>(),
      hospitalBranchUsecase: injection<FetchHospitalBranchUsecase>(),
      financialYearUsecase: injection<FetchUserFinancialYearUsecase>(),
    ),
  );
  injection.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<FetchHospitalBaseUrlUsecase>(
    () => FetchHospitalBaseUrlUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<FetchHospitalBranchUsecase>(
    () => FetchHospitalBranchUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<FetchUserFinancialYearUsecase>(
    () =>
        FetchUserFinancialYearUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: injection<AuthRemoteDatasource>()),
  );
  injection.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(client: injection<DioHttpClient>()),
  );

  // Employee Profile
  injection.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      employeeDetailsUsecase: injection<EmployeeDetailsUsecase>(),
    ),
  );
  injection.registerLazySingleton<EmployeeDetailsUsecase>(
    () => EmployeeDetailsUsecase(repository: injection<EmployeeRepository>()),
  );
  injection.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(
      remoteDatasource: injection<EmployeeRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<EmployeeRemoteDatasource>(
    () => EmployeeRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
  // Employee Attendance
  injection.registerLazySingleton<AttendanceBloc>(
    () => AttendanceBloc(
      currentMonthAttendanceExtendedUsecase:
          injection<CurrentMonthAttendanceExtendedUsecase>(),
      currentMonthAttendancePrimaryUsecase:
          injection<CurrentMonthAttendancePrimaryUsecase>(),
      attendanceSummaryUsecase: injection<AttendanceSummaryUsecase>(),
    ),
  );
  injection.registerLazySingleton<AttendanceSummaryUsecase>(
    () =>
        AttendanceSummaryUsecase(repository: injection<AttendanceRepository>()),
  );
  injection.registerLazySingleton<CurrentMonthAttendancePrimaryUsecase>(
    () => CurrentMonthAttendancePrimaryUsecase(
      repository: injection<AttendanceRepository>(),
    ),
  );
  injection.registerLazySingleton<CurrentMonthAttendanceExtendedUsecase>(
    () => CurrentMonthAttendanceExtendedUsecase(
      repository: injection<AttendanceRepository>(),
    ),
  );
  injection.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDatasource: injection<AttendanceRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<AttendanceRemoteDatasource>(
    () => AttendanceRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
  // Employee (Leave)
  injection.registerLazySingleton<LeaveBloc>(
    () => LeaveBloc(
      leaveHistoryUsecase: injection<LeaveHistoryUsecase>(),
      leaveApplicationHistoryUsecase:
          injection<LeaveApplicationHistoryUsecase>(),
      approvedLeaveListUsecase: injection<ApprovedLeaveListUsecase>(),
      pendingLeaveListUsecase: injection<PendingLeaveListUsecase>(),
      applyLeaveUsecase: injection<ApplyLeaveUsecase>(),
      leaveTypeUsecase: injection<LeaveTypeUsecase>(),
      extendedLeaveTypeUsecase: injection<ExtendedLeaveTypeUsecase>(),
      substitutionLeaveEmployeeUsecase:
          injection<SubstitutionLeaveEmployeeUsecase>(),
    ),
  );
  injection.registerLazySingleton<LeaveTypeUsecase>(
    () => LeaveTypeUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<ExtendedLeaveTypeUsecase>(
    () => ExtendedLeaveTypeUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<SubstitutionLeaveEmployeeUsecase>(
    () => SubstitutionLeaveEmployeeUsecase(
      repository: injection<LeaveRepository>(),
    ),
  );
  injection.registerLazySingleton<ApplyLeaveUsecase>(
    () => ApplyLeaveUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<ApprovedLeaveListUsecase>(
    () => ApprovedLeaveListUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<PendingLeaveListUsecase>(
    () => PendingLeaveListUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<LeaveHistoryUsecase>(
    () => LeaveHistoryUsecase(repository: injection<LeaveRepository>()),
  );
  injection.registerLazySingleton<LeaveApplicationHistoryUsecase>(
    () => LeaveApplicationHistoryUsecase(
      repository: injection<LeaveRepository>(),
    ),
  );
  injection.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(
      remoteDatasource: injection<LeaveRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<LeaveRemoteDatasource>(
    () => LeaveRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
}
