import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';

abstract class LeaveRepository {
  Future<List<LeaveHistoryEntity>> getLeaveHistory();
  Future<List<LeaveApplicationEntity>> getLeaveApplicationHistory();
  Future<List<LeaveApplicationEntity>> getApprovedLeaveList();
  Future<List<LeaveApplicationEntity>> getPendingLeaveList();
}
