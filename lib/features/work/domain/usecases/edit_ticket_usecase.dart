import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class EditTicketUsecase {
  final WorkRepository repository;

  EditTicketUsecase({required this.repository});

  Future<bool> call({
    required int id,
    required String title,
    required String description,
    required String ticketDate,
    required String severity,
    required String priority,
    required int ticketCategoryId,
    // required String ticketCategoryName,
    required int assignToEmployeeId,
    // required String assignedTo,
    required DateTime assignedOn,
    required String issueByEmployeeId,
    // required String issueBy,
    required DateTime issueOn,
    required String sessionTag,
    required int clientId,
    required String client,
    required String clientDesc,
    required String clientDesc2,
    required String? dueDate,
    required List<dynamic> attachmentFiles,
    required List<String> attachedDocuments,
  }) async {
    return await repository.editTicket(
      id: id,
      title: title,
      description: description,
      ticketDate: ticketDate,
      severity: severity,
      priority: priority,
      ticketCategoryId: ticketCategoryId,
      // ticketCategoryName: ticketCategoryName,
      assignToEmployeeId: assignToEmployeeId,
      // assignedTo: assignedTo,
      assignedOn: assignedOn,
      issueByEmployeeId: issueByEmployeeId,
      // issueBy: issueBy,
      issueOn: issueOn,
      sessionTag: sessionTag,
      clientId: clientId,
      clients: client,
      clientDesc: clientDesc,
      clientDesc2: clientDesc2,
      dueDate: dueDate,
      attachmentFiles: attachmentFiles,
      attachedDocuments: attachedDocuments,
    );
  }
}
