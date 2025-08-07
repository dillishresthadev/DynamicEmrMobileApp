part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class GetHospitalBaseUrlEvent extends AuthEvent {
  final String hospitalCode;

  const GetHospitalBaseUrlEvent({required this.hospitalCode});
  @override
  List<Object> get props => [hospitalCode];
}

class LogoutEvent extends AuthEvent {}
