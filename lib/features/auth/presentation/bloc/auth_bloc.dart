import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_branch_usecase.dart';
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
  AuthBloc({
    required this.loginUsecase,
    required this.hospitalBaseUrlUsecase,
    required this.hospitalBranchUsecase,
  }) : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<GetHospitalBaseUrlEvent>(_onGetHospitalBaseUrl);
    on<GetHospitalBranchEvent>(_onGetHospitalBranchEvent);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final loginResponse = await loginUsecase.call(
        UserEntity(username: event.username, password: event.password),
      );

      log('Login successful !! Token : ${loginResponse.token}');
      // save access and refresh token on login success
      injection<TokenSecureStorage>().saveAccessToken(loginResponse.token);
      injection<TokenSecureStorage>().saveRefreshToken(
        loginResponse.refreshToken,
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
      log("Hospital First Branch Name :  ${hospitalBranch.length}");

      emit(AuthHospitalBranchLoadedState(hospitalBranch: hospitalBranch));
    } catch (e) {
      log('Login error: $e');
      emit(AuthErrorState(errorMessage: "Login Failed : $e"));
    }
  }
}
