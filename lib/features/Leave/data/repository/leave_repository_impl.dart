import 'package:dynamic_emr/features/Leave/data/datasource/leave_remote_datasource.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class LeaveRepositoryImpl extends LeaveRepository {
  final LeaveRemoteDatasource remoteDatasource;

  LeaveRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<LeaveApplicationEntity>> getLeaveApplicationHistory() async {
    return await remoteDatasource.getLeaveApplicationHistory();
  }

  @override
  Future<List<LeaveHistoryEntity>> getLeaveHistory() async {
    return await remoteDatasource.getLeaveHistory();
  }

  @override
  Future<List<LeaveApplicationEntity>> getApprovedLeaveList() async {
    return await remoteDatasource.getApprovedLeaveList();
  }

  @override
  Future<List<LeaveApplicationEntity>> getPendingLeaveList() async {
    return await remoteDatasource.getPendingLeaveList();
  }
}
