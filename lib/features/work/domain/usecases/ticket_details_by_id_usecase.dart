import 'package:dynamic_emr/features/work/domain/entities/ticket_details_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class TicketDetailsByIdUsecase {
  final WorkRepository repository;

  TicketDetailsByIdUsecase({required this.repository});

  Future<TicketDetailsEntity> call(int ticketId) async {
    return await repository.getTicketDetailsById(ticketId: ticketId);
  }
}
