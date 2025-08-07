import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/injection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final FetchHospitalBaseUrlUsecase hospitalBaseUrlUsecase;
  AuthBloc({required this.loginUsecase, required this.hospitalBaseUrlUsecase})
    : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<GetHospitalBaseUrlEvent>(_onGetHospitalBaseUrl);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final loginResponse = await loginUsecase.call(
        UserEntity(username: event.username, password: event.password),
      );
      log('Login successful');
      emit(AuthLoginSuccessState(loginResponse: loginResponse));
    } catch (e) {
      log('Login error: $e');

      emit(AuthErrorState(errorMessage: "Login Failed : $e"));
    }
  }

  FutureOr<void> _onGetHospitalBaseUrl(
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
      injection<ISecureStorage>().saveBaseUrl(hospitalBaseUrl);

      emit(HospitalBaseUrlSuccessState());
    } catch (e) {
      log('Login error: $e');
      emit(AuthErrorState(errorMessage: "Login Failed : $e"));
    }
  }
}
