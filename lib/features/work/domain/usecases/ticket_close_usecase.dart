import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class TicketCloseUsecase {
  final WorkRepository repository;

  TicketCloseUsecase({required this.repository});

  Future<bool> call(int ticketId) async {
    return repository.ticketClose(ticketId);
  }
}
