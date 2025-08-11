import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class LeaveHistoryUsecase {
  final LeaveRepository repository;

  LeaveHistoryUsecase({required this.repository});

  Future<List<LeaveHistoryEntity>> call() async {
    return await repository.getLeaveHistory();
  }
}
