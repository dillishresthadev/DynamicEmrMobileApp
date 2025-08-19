import 'package:dynamic_emr/features/Leave/data/datasource/leave_remote_datasource.dart';
import 'package:dynamic_emr/features/Leave/data/models/leave_application_request_model.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
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

  @override
  Future<bool> applyLeave(LeaveApplicationRequestEntity leaveRequest) async {
    final model = LeaveApplicationRequestModel(
      leaveTypeId: leaveRequest.leaveTypeId,
      fromDate: leaveRequest.fromDate,
      fromDateNp: leaveRequest.fromDateNp,
      toDate: leaveRequest.toDate,
      toDateNp: leaveRequest.toDateNp,
      halfDayStatus: leaveRequest.halfDayStatus,
      totalLeaveDays: leaveRequest.totalLeaveDays,
      extendedTotalLeaveDays: leaveRequest.extendedTotalLeaveDays,
      reason: leaveRequest.reason,
      extendedFromDate: leaveRequest.extendedFromDate,
      extendedToDate: leaveRequest.extendedToDate,
      extendedFromDateNp: leaveRequest.extendedFromDateNp,
      extendedLeaveTypeId: leaveRequest.extendedLeaveTypeId,
      substituteEmployeeId: leaveRequest.substituteEmployeeId,
      isHalfDay: leaveRequest.isHalfDay,
    );

    return await remoteDatasource.applyLeave(model);
  }

  @override
  Future<List<LeaveTypeEntity>> getExtendedLeaveType() async {
    return await remoteDatasource.getExtendedLeaveType();
  }

  @override
  Future<List<LeaveTypeEntity>> getLeaveType() async {
    return await remoteDatasource.getLeaveType();
  }

  @override
  Future<List<LeaveTypeEntity>> getSubstitutionLeaveEmployee() async {
    return await remoteDatasource.getSubstitutionLeaveEmployee();
  }

  @override
  Future<List<LeaveTypeEntity>> getContractList() async {
    return await remoteDatasource.getContractList();
  }

  @override
  Future<List<LeaveTypeEntity>> getFiscalYearByContractId(
    int contractId,
  ) async {
    return await remoteDatasource.getFiscalYearByContractId(contractId);
  }

  @override
  Future<List<LeaveHistoryEntity>> getLeaveHistoryByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  ) async {
    return await remoteDatasource.getLeaveHistoryByContractIdAndFiscalYearId(
      contractId,
      fiscalYearId,
    );
  }

  @override
  Future<List<LeaveApplicationEntity>> getLeavesByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  ) async {
    return await remoteDatasource.getLeavesByContractIdAndFiscalYearId(
      contractId,
      fiscalYearId,
    );
  }
}
