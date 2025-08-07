class LoginResponseEntity {
  final String token;
  final String refreshToken;
  final DateTime expiration;

  const LoginResponseEntity({
    required this.token,
    required this.refreshToken,
    required this.expiration,
  });
}
