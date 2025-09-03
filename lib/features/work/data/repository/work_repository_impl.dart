import 'package:dynamic_emr/features/work/data/datasource/work_remote_datasource.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_model.dart';
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
  Future<bool> editTicket(TicketEntity ticket) async {
    return await remoteDatasource.editTicket(
      TicketModel(
        id: ticket.id,
        ticketNo: ticket.ticketNo,
        ticketNoSequence: ticket.ticketNoSequence,
        ticketYearSequence: ticket.ticketYearSequence,
        ticketMonthlySequence: ticket.ticketMonthlySequence,
        ticketDailySequence: ticket.ticketDailySequence,
        ticketMonthlyNpSequence: ticket.ticketMonthlyNpSequence,
        ticketYearlyNpSequence: ticket.ticketYearlyNpSequence,
        ticketFySequence: ticket.ticketFySequence,
        ticketYearlySequenceByCategory: ticket.ticketYearlySequenceByCategory,
        ticketMonthlySequenceByCategory: ticket.ticketMonthlySequenceByCategory,
        ticketDailySequenceByCategory: ticket.ticketDailySequenceByCategory,
        ticketNo2: ticket.ticketNo2,
        applicationUserId: ticket.applicationUserId,
        title: ticket.title,
        description: ticket.description,
        ticketDate: ticket.ticketDate,
        status: ticket.status,
        severity: ticket.severity,
        priority: ticket.priority,
        ticketCategoryId: ticket.ticketCategoryId,
        ticketCategoryName: ticket.ticketCategoryName,
        assignToEmployeeId: ticket.assignToEmployeeId,
        assignedTo: ticket.assignedTo,
        assignedOn: ticket.assignedOn,
        issueBy: ticket.issueBy,
        issueOn: ticket.issueOn,
        attachedDocuments: ticket.attachedDocuments,
        insertUser: ticket.insertUser,
        insertTime: ticket.insertTime,
        updateUser: ticket.updateUser,
      ),
    );
  }
}
