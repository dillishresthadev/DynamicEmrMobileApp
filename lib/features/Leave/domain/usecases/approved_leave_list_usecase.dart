import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class ApprovedLeaveListUsecase {
  final LeaveRepository repository;

  ApprovedLeaveListUsecase({required this.repository});

  Future<List<LeaveApplicationEntity>> call() async {
    return await repository.getApprovedLeaveList();
  }
}
