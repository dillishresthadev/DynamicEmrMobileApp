import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';

abstract class LeaveRepository {
  Future<List<LeaveHistoryEntity>> getLeaveHistory();
  Future<List<LeaveApplicationEntity>> getLeaveApplicationHistory();
  Future<List<LeaveApplicationEntity>> getApprovedLeaveList();
  Future<List<LeaveApplicationEntity>> getPendingLeaveList();
  Future<bool> applyLeave(LeaveApplicationRequestEntity leaveRequest);
  Future<List<LeaveTypeEntity>> getLeaveType();
  Future<List<LeaveTypeEntity>> getExtendedLeaveType();
  Future<List<LeaveTypeEntity>> getSubstitutionLeaveEmployee();
  Future<List<LeaveTypeEntity>> getContractList();
  Future<List<LeaveTypeEntity>> getFiscalYearByContractId(int contractId);
  Future<List<LeaveHistoryEntity>> getLeaveHistoryByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  );
  Future<List<LeaveApplicationEntity>> getLeavesByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  );
}
