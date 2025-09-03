import 'package:dynamic_emr/features/work/data/datasource/work_remote_datasource.dart';
import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class WorkRepositoryImpl extends WorkRepository {
  final WorkRemoteDatasource remoteDatasource;

  WorkRepositoryImpl({required this.remoteDatasource});
  @override
  Future<TicketSummaryEntity> getMyTicketSummary() async {
    return await remoteDatasource.getMyTicketSummary();
  }

  @override
  Future<TicketSummaryEntity> getTicketAssignedToMeSummary() async {
    return await remoteDatasource.getTicketAssignedToMeSummary();
  }

  @override
  Future<List<TicketCategoriesEntity>> getTicketCategories() async {
    return await remoteDatasource.getTicketCategories();
  }

  @override
  Future<TicketDetailsEntity> getTicketDetailsById({
    required int ticketId,
  }) async {
    return await remoteDatasource.getTicketDetailsById(ticketId: ticketId);
  }

  @override
  Future<List<WorkUserEntity>> getWorkUserList() async {
    return await remoteDatasource.getWorkUserList();
  }

  @override
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
  ) async {
    return await remoteDatasource.createNewTicket(
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
      attachmentPaths,
    );
  }

  @override
  Future<List<TicketEntity>> getFilteredMyAssignedTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    return await remoteDatasource.getFilteredMyTickets(
      ticketCategoryId,
      status,
      priority,
      severity,
      assignTo,
      fromDate,
      toDate,
      orderBy,
    );
  }

  @override
  Future<List<TicketEntity>> getFilteredMyTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    return await remoteDatasource.getFilteredMyAssignedTickets(
      ticketCategoryId,
      status,
      priority,
      severity,
      assignTo,
      fromDate,
      toDate,
      orderBy,
    );
  }

  @override
  Future<bool> ticketClose(int ticketId) async {
    return await remoteDatasource.closeTicket(ticketId);
  }

  @override
  Future<bool> ticketReopen(int ticketId) async {
    return await remoteDatasource.reOpenTicket(ticketId);
  }

  @override
  Future<bool> commentOnTicket(
    int ticketId,
    String message,
    List<String>? attachmentPaths,
  ) async {
    return await remoteDatasource.commentOnTicket(
      ticketId,
      message,
      attachmentPaths,
    );
  }

  @override
  Future<bool> editAssignTo(int ticketId, int assignedUserId) async {
    return await remoteDatasource.editAssignTo(ticketId, assignedUserId);
  }

  @override
  Future<bool> editPriority(int ticketId, String status) async {
    return await remoteDatasource.editPriority(ticketId, status);
  }

  @override
  Future<bool> editSeverity(int ticketId, String status) async {
    return await remoteDatasource.editSeverity(ticketId, status);
  }

  @override
  Future<List<BusinessClientEntity>> getBusinessClient() async {
    return await remoteDatasource.getBusinessClient();
  }

  @override
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
    required List attachmentFiles,
    required List<String> attachedDocuments,
  }) async {
    return await remoteDatasource.editTicket(
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
      clients: clients,
      clientDesc: clientDesc,
      clientDesc2: clientDesc2,
      dueDate: dueDate,
      attachmentFiles: attachmentFiles,
      attachedDocuments: attachedDocuments,
    );
  }
}
