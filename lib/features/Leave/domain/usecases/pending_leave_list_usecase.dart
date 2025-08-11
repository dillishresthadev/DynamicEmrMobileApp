import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class PendingLeaveListUsecase {
  final LeaveRepository repository;

  PendingLeaveListUsecase({required this.repository});

  Future<List<LeaveApplicationEntity>> call() async {
    return await repository.getPendingLeaveList();
  }
}
