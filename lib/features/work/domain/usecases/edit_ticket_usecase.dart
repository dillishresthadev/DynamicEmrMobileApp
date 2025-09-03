import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class EditTicketUsecase {
  final WorkRepository repository;

  EditTicketUsecase({required this.repository});

  Future<bool> call(TicketEntity ticket) async {
    return await repository.editTicket(ticket);
  }
}
