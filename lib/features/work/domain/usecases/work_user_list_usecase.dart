import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class WorkUserListUsecase {
  final WorkRepository repository;

  WorkUserListUsecase({required this.repository});

  Future<List<WorkUserEntity>> call() async {
    return await repository.getWorkUserList();
  }
}
