import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UserRepository repository;

  LoginUsecase({required this.repository});
  Future<LoginResponseEntity> call(UserEntity user) async {
    return await repository.login(
      username: user.username,
      password: user.password,
    );
  }
}
