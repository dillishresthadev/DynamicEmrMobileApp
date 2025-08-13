import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class CreateNewTicketUsecase {
  final WorkRepository repository;

  CreateNewTicketUsecase({required this.repository});

  Future<bool> call(
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    int assignToEmployeeId,
    List<String>? attachmentPaths,
  ) async {
    return await repository.createNewTicket(
      ticketCategoryId,
      title,
      description,
      severity,
      priority,
      assignToEmployeeId,
      attachmentPaths,
    );
  }
}
