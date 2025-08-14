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
  Future<List<TicketCategoriesEntity>> getTicketCategories();
  Future<bool> createNewTicket(
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
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
}
