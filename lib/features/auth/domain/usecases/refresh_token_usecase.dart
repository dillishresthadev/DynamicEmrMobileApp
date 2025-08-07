import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class RefreshTokenUsecase {
  final UserRepository repository;

  RefreshTokenUsecase({required this.repository});
  Future<String?> call(String refreshToken) async {
    return await repository.refreshToken(refreshToken: refreshToken);
  }
}
