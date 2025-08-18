import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class EditPriorityUsecase {
  final WorkRepository repository;

  EditPriorityUsecase({required this.repository});

  Future<bool> call(int ticketId, String status) async {
    return await repository.editPriority(ticketId, status);
  }
}
