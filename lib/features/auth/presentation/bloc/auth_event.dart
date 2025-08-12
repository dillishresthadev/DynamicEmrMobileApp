part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent({required this.refreshToken});
  @override
  List<Object?> get props => [refreshToken];
}

class GetHospitalBaseUrlEvent extends AuthEvent {
  final String hospitalCode;

  const GetHospitalBaseUrlEvent({required this.hospitalCode});
  @override
  List<Object> get props => [hospitalCode];
}

class GetHospitalBranchEvent extends AuthEvent {}

class GetHospitalFinancialYearEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
