import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class CreateNewTicketUsecase {
  final WorkRepository repository;

  CreateNewTicketUsecase({required this.repository});

  Future<bool> call(
    String ticketDate,
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    String client,
    String clientDesc,
    String clientDesc2,
    String dueDate,
    int assignToEmployeeId,
    int issueByEmployeeId,
    List<String>? attachmentPaths,
  ) async {
    return await repository.createNewTicket(
      ticketDate,
      ticketCategoryId,
      title,
      description,
      severity,
      priority,
      client,
      clientDesc,
      clientDesc2,
      dueDate,
      assignToEmployeeId,
      issueByEmployeeId,
      attachmentPaths,
    );
  }
}
