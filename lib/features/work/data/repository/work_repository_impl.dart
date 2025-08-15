import 'package:dynamic_emr/features/work/data/datasource/work_remote_datasource.dart';
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
    int assignToEmployeeId,
    List<String>? attachmentPaths,
  ) async {
    return await remoteDatasource.createNewTicket(
      ticketCategoryId,
      title,
      description,
      severity,
      priority,
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
  Future<bool> commentOnTicket(int ticketId, String message) async {
    return await remoteDatasource.commentOnTicket(ticketId, message);
  }
}
