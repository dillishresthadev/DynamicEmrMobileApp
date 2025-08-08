import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository repository;

  RefreshTokenUsecase({required this.repository});
  Future<String?> call(String refreshToken) async {
    return await repository.refreshToken(refreshToken: refreshToken);
  }
}
