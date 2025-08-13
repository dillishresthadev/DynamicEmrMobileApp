import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class TicketAssignedToMeSummaryUsecase {
  final WorkRepository repository;

  TicketAssignedToMeSummaryUsecase({required this.repository});
  Future<TicketSummaryEntity> call() async {
    return await repository.getTicketAssignedToMeSummary();
  }
}
