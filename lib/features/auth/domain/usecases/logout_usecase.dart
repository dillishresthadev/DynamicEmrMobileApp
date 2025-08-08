import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
