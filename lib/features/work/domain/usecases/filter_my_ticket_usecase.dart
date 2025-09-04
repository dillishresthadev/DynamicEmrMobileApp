import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class FilterMyTicketUsecase {
  final WorkRepository repository;

  FilterMyTicketUsecase({required this.repository});
  Future<List<TicketEntity>> call(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    int clientId,
    String clientDesc,
    String clientDesc2,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    return await repository.getFilteredMyTickets(
      ticketCategoryId,
      status,
      priority,
      severity,
      assignTo,
      clientId,
      clientDesc,
      clientDesc2,
      fromDate,
      toDate,
      orderBy,
    );
  }
}
