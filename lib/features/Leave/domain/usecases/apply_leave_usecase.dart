import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class ApplyLeaveUsecase {
  final LeaveRepository repository;

  ApplyLeaveUsecase({required this.repository});

  Future<bool> call(LeaveApplicationRequestEntity leaveRequest) async {
    return await repository.applyLeave(leaveRequest);
  }
}
