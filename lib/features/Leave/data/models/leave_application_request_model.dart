import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';

class LeaveApplicationRequestModel extends LeaveApplicationRequestEntity {
  LeaveApplicationRequestModel({
    super.leaveTypeId,
    super.fromDate,
    super.fromDateNp,
    super.toDate,
    super.toDateNp,
    super.halfDayStatus,
    super.totalLeaveDays,
    super.reason,
    super.extendedFromDate,
    super.extendedToDate,
    super.extendedFromDateNp,
    super.extendedToDateNp,
    super.extendedLeaveTypeId,
    super.substituteEmployeeId,
    super.isHalfDay,
  });

  factory LeaveApplicationRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationRequestModel(
      leaveTypeId: json['leaveTypeId'] as int?,
      fromDate: json['fromDate'] as String?,
      fromDateNp: json['fromDateNp'] as String?,
      toDate: json['toDate'] as String?,
      toDateNp: json['toDateNp'] as String?,
      halfDayStatus: json['halfDayStatus'] as String?,
      totalLeaveDays: json['totalLeaveDays'] as int?,
      reason: json['reason'] as String?,
      extendedFromDate: json['extendedFromDate'] as String?,
      extendedToDate: json['extendedToDate'] as String?,
      extendedFromDateNp: json['extendedFromDateNp'] as String?,
      extendedToDateNp: json['extendedToDateNp'] as String?,
      extendedLeaveTypeId: json['extendedLeaveTypeId'] as int?,
      substituteEmployeeId: json['substituteEmployeeId'] as int?,
      isHalfDay: json['isHalfDay'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveTypeId': leaveTypeId,
      'fromDate': fromDate,
      'fromDateNp': fromDateNp,
      'toDate': toDate,
      'toDateNp': toDateNp,
      'halfDayStatus': halfDayStatus,
      'totalLeaveDays': totalLeaveDays,
      'reason': reason,
      'extendedFromDate': extendedFromDate,
      'extendedToDate': extendedToDate,
      'extendedFromDateNp': extendedFromDateNp,
      'extendedToDateNp': extendedToDateNp,
      'extendedLeaveTypeId': extendedLeaveTypeId,
      'substituteEmployeeId': substituteEmployeeId,
      'isHalfDay': isHalfDay,
    };
  }
}
