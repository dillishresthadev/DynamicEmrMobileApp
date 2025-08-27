class LeaveApplicationRequestEntity {
  // int? id;
  // String? applicationDate;
  // String? applicationDateNp;
  int? leaveTypeId;
  // int? employeeId;
  String? fromDate;
  String? fromDateNp;
  String? toDate;
  String? toDateNp;
  String? halfDayStatus;
  double? totalLeaveDays;
  int? extendedTotalLeaveDays;
  String? reason;
  String? extendedFromDate;
  String? extendedToDate;
  String? extendedFromDateNp;
  String? extendedToDateNp;
  int? extendedLeaveTypeId;
  int? substituteEmployeeId;
  bool? isHalfDay;

  LeaveApplicationRequestEntity({
    this.leaveTypeId,
    this.fromDate,
    this.fromDateNp,
    this.toDate,
    this.toDateNp,
    this.halfDayStatus,
    this.totalLeaveDays,
    this.extendedTotalLeaveDays,
    this.reason,
    this.extendedFromDate,
    this.extendedToDate,
    this.extendedFromDateNp,
    this.extendedToDateNp,
    this.extendedLeaveTypeId,
    this.substituteEmployeeId,
    this.isHalfDay,
  });
}
