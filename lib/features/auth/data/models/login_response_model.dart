import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.token,
    required super.refreshToken,
    required super.expiration,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );
  }
}
