import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class LeaveApplicationHistoryUsecase {
  final LeaveRepository repository;

  LeaveApplicationHistoryUsecase({required this.repository});

  Future<List<LeaveApplicationEntity>> call() async {
    return await repository.getLeaveApplicationHistory();
  }
}
