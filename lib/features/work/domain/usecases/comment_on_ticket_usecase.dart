import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class CommentOnTicketUsecase {
  final WorkRepository repository;

  CommentOnTicketUsecase({required this.repository});

  Future<bool> call(int ticketId,String message) async {
    return repository.commentOnTicket(ticketId,message);
  }
}
