import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';

abstract class WorkRepository {
  Future<TicketSummaryEntity> getMyTicketSummary();
  Future<TicketSummaryEntity> getTicketAssignedToMeSummary();
  Future<TicketDetailsEntity> getTicketDetailsById({required int ticketId});
  Future<List<WorkUserEntity>> getWorkUserList();
  Future<List<TicketCategoriesEntity>> getTicketCategories();
}
