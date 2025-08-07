import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class LogoutUsecase {
  final UserRepository repository;

  LogoutUsecase({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
