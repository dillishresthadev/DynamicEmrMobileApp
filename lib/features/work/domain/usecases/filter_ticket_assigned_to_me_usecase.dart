import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class FilterTicketAssignedToMeUsecase {
  final WorkRepository repository;

  FilterTicketAssignedToMeUsecase({required this.repository});
  Future<List<TicketEntity>> call(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    return await repository.getFilteredMyAssignedTickets(
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
}
