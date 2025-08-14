import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class TicketReopenUsecase {
  final WorkRepository repository;

  TicketReopenUsecase({required this.repository});

  Future<bool> call(int ticketId) async {
    return repository.ticketReopen(ticketId);
  }
}
