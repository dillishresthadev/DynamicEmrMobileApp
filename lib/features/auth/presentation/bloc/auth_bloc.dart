import 'dart:async';
import 'dart:developer';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_branch_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_user_financial_year_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/refresh_token_usecase.dart';
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
  final RefreshTokenUsecase refreshTokenUsecase;
  AuthBloc({
    required this.loginUsecase,
    required this.hospitalBaseUrlUsecase,
    required this.hospitalBranchUsecase,
    required this.financialYearUsecase,
    required this.refreshTokenUsecase,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<RefreshTokenEvent>(_onRefreshToken);
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
      final tokenStorage = injection<TokenSecureStorage>();

      final accessToken = await tokenStorage.getAccessToken();
      final refreshToken = await tokenStorage.getRefreshToken();
      final expirationTime = await tokenStorage.getTokenExpirationTime();

      log("Checking auth status:");
      log("Access Token: $accessToken");
      log("Refresh Token: $refreshToken");
      log("Expiration Time: $expirationTime");

      // If missing tokens, user is unauthenticated
      if (accessToken == null ||
          refreshToken == null ||
          expirationTime == null) {
        log("Missing token data — logging out.");
        emit(AuthUnauthenticated());
        return;
      }

      final now = DateTime.now();

      // Token still valid — skip refresh
      if (now.isBefore(expirationTime)) {
        log("Token is still valid — skipping refresh.");
        emit(
          AuthLoginSuccessState(
            loginResponse: LoginResponseEntity(
              token: accessToken,
              refreshToken: refreshToken,
              expiration: expirationTime,
            ),
          ),
        );
        return;
      }

      // Token expired — try refresh
      log("Token expired, attempting refresh...");
      final loginResponse = await authRepo.refreshToken(
        refreshToken: refreshToken,
      );

      if (loginResponse?.token != null) {
        // Save new tokens
        await tokenStorage.saveAccessToken(loginResponse!.token);
        await tokenStorage.saveRefreshToken(loginResponse.refreshToken);
        await tokenStorage.saveTokenExpirationTime(loginResponse.expiration);

        log("Token refresh successful.");
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
        log("Token refresh failed — logging out.");
        await authRepo.logout();
        emit(AuthUnauthenticated());
      }
    } catch (e, stackTrace) {
      log("Error in _onCheckAuthStatus: $e", stackTrace: stackTrace);
      emit(
        AuthErrorState(
          errorMessage: 'Failed to check auth status. Please try again.',
        ),
      );
      emit(AuthUnauthenticated());
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

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      await refreshTokenUsecase.call(event.refreshToken);
    } catch (e) {
      log('Refresh Token error: $e');
      emit(AuthErrorState(errorMessage: "Refresh Token : $e"));
    }
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

      emit(AuthErrorState(errorMessage: "Login Failed"));
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
      emit(AuthErrorState(errorMessage: "Login Failed"));
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
      emit(AuthErrorState(errorMessage: "Failed getting branch"));
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
      emit(AuthErrorState(errorMessage: "Failed getting Financial Year data"));
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
      // await injection<ISecureStorage>().removeHospitalCode();
      // await injection<ISecureStorage>().removeHospitalBaseUrl();
      emit(AuthLogoutSuccessState());
    } catch (e) {
      log("Error Logging out :$e");
      emit(AuthLogoutErrorState(errorMessage: "Error Logging out"));
    }
  }
}
