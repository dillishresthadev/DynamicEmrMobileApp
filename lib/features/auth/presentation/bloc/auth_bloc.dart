import 'dart:async';
import 'dart:developer';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/connectivity_check.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_branch_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_user_financial_year_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final FetchHospitalBaseUrlUsecase hospitalBaseUrlUsecase;
  final FetchHospitalBranchUsecase hospitalBranchUsecase;
  final FetchUserFinancialYearUsecase financialYearUsecase;
  AuthBloc({
    required this.loginUsecase,
    required this.hospitalBaseUrlUsecase,
    required this.hospitalBranchUsecase,
    required this.financialYearUsecase,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);

    on<LoginEvent>(_onLogin);
    on<GetHospitalBaseUrlEvent>(_onGetHospitalBaseUrl);
    on<GetHospitalBranchEvent>(_onGetHospitalBranchEvent);
    on<GetHospitalFinancialYearEvent>(_onGetHospitalFinancialYear);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final authRepo = injection<AuthRepository>();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final refreshToken = await injection<TokenSecureStorage>()
          .getRefreshToken();

      final connectivityCheck = injection<ConnectivityCheck>();

      log(
        'Checking auth status - Token: $accessToken, RefreshToken: $refreshToken ',
      );

      final isConnected = await connectivityCheck.isConnected;

      // If offline, allow login with existing credentials
      if (!isConnected) {
        emit(AuthErrorState(errorMessage: "No Internet"));
      }

      // If token expires refresh access token
      if (await isTokenExpired()) {
        if (refreshToken == null) {
          emit(AuthUnauthenticated());
        }
        // Try to refresh the token
        final loginResponse = await authRepo.refreshToken(
          refreshToken: refreshToken!,
        );
        if (loginResponse?.token != null) {
          // save new access token ,refresh token and expiration time
          await injection<TokenSecureStorage>().saveAccessToken(
            loginResponse!.token,
          );
          await injection<TokenSecureStorage>().saveRefreshToken(
            loginResponse.refreshToken,
          );
          await injection<TokenSecureStorage>().saveTokenExpirationTime(
            loginResponse.expiration,
          );
          emit(
            AuthLoginSuccessState(
              loginResponse: LoginResponseEntity(
                token: loginResponse.token,
                refreshToken: loginResponse.refreshToken,
                expiration: loginResponse.expiration,
              ),
            ),
          );
        } else {
          await authRepo.logout();
          emit(AuthUnauthenticated());
        }
      }
    } catch (e) {
      log('Error in _onCheckAuthStatus: $e');
      emit(
        AuthErrorState(
          errorMessage: 'Failed to check auth status. Please try again.',
        ),
      );
    }
  }

  Future<bool> isTokenExpired() async {
    final expirationTime = await injection<TokenSecureStorage>()
        .getTokenExpirationTime();
    log("Expiration time: $expirationTime");
    if (expirationTime == null) return true;
    final currentTime = DateTime.now();
    log("Current time: $currentTime -- Exp time $expirationTime");
    return currentTime.isAfter(expirationTime);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final loginResponse = await loginUsecase.call(
        UserEntity(username: event.username, password: event.password),
      );

      log('Login successful !! Token : ${loginResponse.token}');
      // save access and refresh token on login success
      await injection<TokenSecureStorage>().saveAccessToken(
        loginResponse.token,
      );
      await injection<TokenSecureStorage>().saveRefreshToken(
        loginResponse.refreshToken,
      );
      await injection<TokenSecureStorage>().saveTokenExpirationTime(
        loginResponse.expiration,
      );

      emit(AuthLoginSuccessState(loginResponse: loginResponse));
    } catch (e) {
      log('Login error: $e');

      emit(AuthErrorState(errorMessage: "Login Failed : $e"));
    }
  }

  Future<void> _onGetHospitalBaseUrl(
    GetHospitalBaseUrlEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final hospitalBaseUrl = await hospitalBaseUrlUsecase.call(
        event.hospitalCode,
      );
      log("Hospital Base URL $hospitalBaseUrl");
      // save hospital base URL for further API calls
      injection<ISecureStorage>().saveHospitalBaseUrl(hospitalBaseUrl);

      emit(HospitalBaseUrlSuccessState());
    } catch (e) {
      log('Login error: $e');
      emit(AuthErrorState(errorMessage: "Login Failed : $e"));
    }
  }

  Future<void> _onGetHospitalBranchEvent(
    GetHospitalBranchEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final List<HospitalBranchEntity> hospitalBranch =
          await hospitalBranchUsecase.call();
      log("Branch count :  ${hospitalBranch.length}");

      emit(AuthHospitalBranchLoadedState(hospitalBranch: hospitalBranch));
    } catch (e) {
      log('Failed getting branch: $e');
      emit(AuthErrorState(errorMessage: "Failed getting branch : $e"));
    }
  }

  Future<void> _onGetHospitalFinancialYear(
    GetHospitalFinancialYearEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final List<UserFinancialYearEntity> financialYear =
          await financialYearUsecase.call();
      log("Financial Year count :  ${financialYear.length}");

      emit(AuthHospitalFinancialYearState(financialYear: financialYear));
    } catch (e) {
      log('Failed getting Financial Year data: $e');
      emit(
        AuthErrorState(
          errorMessage: "Failed getting Financial Year data  : $e",
        ),
      );
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await injection<TokenSecureStorage>().removeAccessToken();
      await injection<TokenSecureStorage>().removeRefreshToken();
      await injection<TokenSecureStorage>().removeExpirationTime();
      await injection<BranchSecureStorage>().removeSelectedFiscalYearId();
      await injection<BranchSecureStorage>().removeWorkingBranchId();
      await injection<ISecureStorage>().removeHospitalCode();
      await injection<ISecureStorage>().removeHospitalBaseUrl();
      emit(AuthLogoutSuccessState());
    } catch (e) {
      log("Error Logging out :$e");
      emit(AuthLogoutErrorState(errorMessage: e.toString()));
    }
  }
}
