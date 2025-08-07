import 'package:dynamic_emr/features/auth/domain/entities/user_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class FetchUserBranchUsecase {
  final UserRepository repository;

  FetchUserBranchUsecase({required this.repository});

  Future<List<UserBranchEntity>> call() async {
    return await repository.getUserBranches();
  }
}
