part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthLoginSuccessState extends AuthState {
  final LoginResponseEntity loginResponse;

  const AuthLoginSuccessState({required this.loginResponse});
  @override
  List<Object> get props => [loginResponse];
}

final class HospitalBaseUrlSuccessState extends AuthState {}

final class AuthHospitalBranchLoadedState extends AuthState {
  final List<HospitalBranchEntity> hospitalBranch;

  const AuthHospitalBranchLoadedState({required this.hospitalBranch});
  @override
  List<Object> get props => [hospitalBranch];
}

final class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
