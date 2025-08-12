import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class LeaveTypeUsecase {
  final LeaveRepository repository;

  LeaveTypeUsecase({required this.repository});

  Future<List<LeaveTypeEntity>> call() async {
    return await repository.getLeaveType();
  }
}
