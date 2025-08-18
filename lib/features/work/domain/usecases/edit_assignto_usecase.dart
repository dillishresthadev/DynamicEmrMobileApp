import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class EditAssigntoUsecase {
  final WorkRepository repository;

  EditAssigntoUsecase({required this.repository});

  Future<bool> call(int ticketId, int assignedUserId) async {
    return await repository.editAssignTo(ticketId, assignedUserId);
  }
}
