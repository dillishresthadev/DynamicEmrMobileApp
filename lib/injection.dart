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
import 'package:dynamic_emr/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dynamic_emr/features/holiday/data/datasource/holiday_remote_datasource.dart';
import 'package:dynamic_emr/features/holiday/data/repository/holiday_repository_impl.dart';
import 'package:dynamic_emr/features/holiday/domain/repository/holiday_repository.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/all_holiday_list_usecase.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/past_holiday_list_usecase.dart';
import 'package:dynamic_emr/features/holiday/domain/usecases/upcomming_holiday_list_usecase.dart';
import 'package:dynamic_emr/features/holiday/presentation/bloc/holiday_bloc.dart';
import 'package:dynamic_emr/features/notice/data/datasource/notice_remote_datasource.dart';
import 'package:dynamic_emr/features/notice/data/repository/notice_repository_impl.dart';
import 'package:dynamic_emr/features/notice/domain/repository/notice_repository.dart';
import 'package:dynamic_emr/features/notice/domain/usecases/notice_by_id_usecase.dart';
import 'package:dynamic_emr/features/notice/domain/usecases/notice_usecase.dart';
import 'package:dynamic_emr/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:dynamic_emr/features/payrolls/data/datasource/payroll_remote_datasource.dart';
import 'package:dynamic_emr/features/payrolls/data/repository/payroll_repository_impl.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/current_month_salary_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/loan_and_advance_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/monthly_salary_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/taxes_usecase.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:dynamic_emr/features/profile/data/datasources/employee_remote_datasource.dart';
import 'package:dynamic_emr/features/profile/data/repository/employee_repository_impl.dart';
import 'package:dynamic_emr/features/profile/domain/repository/employee_repository.dart';
import 'package:dynamic_emr/features/profile/domain/usecases/employee_details_usecase.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/work/data/datasource/work_remote_datasource.dart';
import 'package:dynamic_emr/features/work/data/repository/work_repository_impl.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';
import 'package:dynamic_emr/features/work/domain/usecases/comment_on_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/create_new_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/filter_my_ticket_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/filter_ticket_assigned_to_me_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_assigned_to_me_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_categories_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_close_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_details_by_id_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_reopen_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/ticket_summary_usecase.dart';
import 'package:dynamic_emr/features/work/domain/usecases/work_user_list_usecase.dart';
import 'package:dynamic_emr/features/work/presentation/bloc/work_bloc.dart';
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
      refreshTokenUsecase: injection<RefreshTokenUsecase>(),
    ),
  );
  injection.registerLazySingleton<RefreshTokenUsecase>(
    () => RefreshTokenUsecase(repository: injection<AuthRepository>()),
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
  // Work (Task/Tickets)

  injection.registerLazySingleton<WorkBloc>(
    () => WorkBloc(
      ticketSummaryUsecase: injection<TicketSummaryUsecase>(),
      ticketAssignedToMeSummaryUsecase:
          injection<TicketAssignedToMeSummaryUsecase>(),
      workUserListUsecase: injection<WorkUserListUsecase>(),
      ticketCategoriesUsecase: injection<TicketCategoriesUsecase>(),
      createNewTicketUsecase: injection<CreateNewTicketUsecase>(),
      filterMyTicketUsecase: injection<FilterMyTicketUsecase>(),
      filterTicketAssignedToMeUsecase:
          injection<FilterTicketAssignedToMeUsecase>(),
      ticketDetailsByIdUsecase: injection<TicketDetailsByIdUsecase>(),
      ticketCloseUsecase: injection<TicketCloseUsecase>(),
      ticketReopenUsecase: injection<TicketReopenUsecase>(),
      commentOnTicketUsecase: injection<CommentOnTicketUsecase>(),
    ),
  );

  injection.registerLazySingleton<CommentOnTicketUsecase>(
    () => CommentOnTicketUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<TicketCloseUsecase>(
    () => TicketCloseUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<TicketReopenUsecase>(
    () => TicketReopenUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<TicketDetailsByIdUsecase>(
    () => TicketDetailsByIdUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<FilterMyTicketUsecase>(
    () => FilterMyTicketUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<FilterTicketAssignedToMeUsecase>(
    () => FilterTicketAssignedToMeUsecase(
      repository: injection<WorkRepository>(),
    ),
  );
  injection.registerLazySingleton<CreateNewTicketUsecase>(
    () => CreateNewTicketUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<WorkUserListUsecase>(
    () => WorkUserListUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<TicketCategoriesUsecase>(
    () => TicketCategoriesUsecase(repository: injection<WorkRepository>()),
  );

  injection.registerLazySingleton<TicketAssignedToMeSummaryUsecase>(
    () => TicketAssignedToMeSummaryUsecase(
      repository: injection<WorkRepository>(),
    ),
  );
  injection.registerLazySingleton<TicketSummaryUsecase>(
    () => TicketSummaryUsecase(repository: injection<WorkRepository>()),
  );
  injection.registerLazySingleton<WorkRepository>(
    () =>
        WorkRepositoryImpl(remoteDatasource: injection<WorkRemoteDatasource>()),
  );
  injection.registerLazySingleton<WorkRemoteDatasource>(
    () => WorkRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );

  // payrolls
  injection.registerLazySingleton<PayrollBloc>(
    () => PayrollBloc(
      currentMonthSalaryUsecase: injection<CurrentMonthSalaryUsecase>(),
      monthlySalaryUsecase: injection<MonthlySalaryUsecase>(),
      loanAndAdvanceUsecase: injection<LoanAndAdvanceUsecase>(),
      taxesUsecase: injection<TaxesUsecase>(),
    ),
  );

  injection.registerLazySingleton<MonthlySalaryUsecase>(
    () => MonthlySalaryUsecase(repository: injection<PayrollRepository>()),
  );
  injection.registerLazySingleton<TaxesUsecase>(
    () => TaxesUsecase(repository: injection<PayrollRepository>()),
  );
  injection.registerLazySingleton<LoanAndAdvanceUsecase>(
    () => LoanAndAdvanceUsecase(repository: injection<PayrollRepository>()),
  );
  injection.registerLazySingleton<CurrentMonthSalaryUsecase>(
    () => CurrentMonthSalaryUsecase(repository: injection<PayrollRepository>()),
  );
  injection.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(
      remoteDatasource: injection<PayrollRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<PayrollRemoteDatasource>(
    () => PayrollRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
  // notice
  injection.registerLazySingleton<NoticeBloc>(
    () => NoticeBloc(
      noticeByIdUsecase: injection<NoticeByIdUsecase>(),
      noticeUsecase: injection<NoticeUsecase>(),
    ),
  );
  injection.registerLazySingleton<NoticeUsecase>(
    () => NoticeUsecase(repository: injection<NoticeRepository>()),
  );
  injection.registerLazySingleton<NoticeByIdUsecase>(
    () => NoticeByIdUsecase(repository: injection<NoticeRepository>()),
  );
  injection.registerLazySingleton<NoticeRepository>(
    () => NoticeRepositoryImpl(
      remoteDatasource: injection<NoticeRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<NoticeRemoteDatasource>(
    () => NoticeRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
  // Holiday
  injection.registerLazySingleton<HolidayBloc>(
    () => HolidayBloc(
      allHolidayListUsecase: injection<AllHolidayListUsecase>(),
      pastHolidayListUsecase: injection<PastHolidayListUsecase>(),
      upcommingHolidayListUsecase: injection<UpcommingHolidayListUsecase>(),
    ),
  );
  injection.registerLazySingleton<AllHolidayListUsecase>(
    () => AllHolidayListUsecase(repository: injection<HolidayRepository>()),
  );
  injection.registerLazySingleton<PastHolidayListUsecase>(
    () => PastHolidayListUsecase(repository: injection<HolidayRepository>()),
  );
  injection.registerLazySingleton<UpcommingHolidayListUsecase>(
    () =>
        UpcommingHolidayListUsecase(repository: injection<HolidayRepository>()),
  );
  injection.registerLazySingleton<HolidayRepository>(
    () => HolidayRepositoryImpl(
      remoteDatasource: injection<HolidayRemoteDatasource>(),
    ),
  );
  injection.registerLazySingleton<HolidayRemoteDatasource>(
    () => HolidayRemoteDatasourceImpl(client: injection<DioHttpClient>()),
  );
}
