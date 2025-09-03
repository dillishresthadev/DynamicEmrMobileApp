import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';

abstract class WorkRepository {
  Future<TicketSummaryEntity> getMyTicketSummary();
  Future<TicketSummaryEntity> getTicketAssignedToMeSummary();
  Future<TicketDetailsEntity> getTicketDetailsById({required int ticketId});
  Future<List<WorkUserEntity>> getWorkUserList();
  Future<bool> ticketReopen(int ticketId);
  Future<bool> ticketClose(int ticketId);
  Future<bool> commentOnTicket(
    int ticketId,
    String message,
    List<String>? attachmentPaths,
  );
  Future<List<TicketCategoriesEntity>> getTicketCategories();
  Future<bool> createNewTicket(
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
    List<String>? attachmentPaths,
  );

  Future<List<TicketEntity>> getFilteredMyTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    String fromDate,
    String toDate,
    String orderBy,
  );
  Future<List<TicketEntity>> getFilteredMyAssignedTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    String fromDate,
    String toDate,
    String orderBy,
  );

  Future<bool> editPriority(int ticketId, String status);
  Future<bool> editSeverity(int ticketId, String status);
  Future<bool> editAssignTo(int ticketId, int assignedUserId);

  Future<List<BusinessClientEntity>> getBusinessClient();

  Future<bool> editTicket({
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
    required String clients,
    required String clientDesc,
    required String clientDesc2,
    required String? dueDate,
    required List<dynamic> attachmentFiles,
    required List<String> attachedDocuments,
  });
}
