import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class EditSeverityUsecase {
  final WorkRepository repository;

  EditSeverityUsecase({required this.repository});

  Future<bool> call(int ticketId, String status) async {
    return await repository.editSeverity(ticketId, status);
  }
}
