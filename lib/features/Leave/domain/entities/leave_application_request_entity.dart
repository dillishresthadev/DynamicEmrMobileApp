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
  int? totalLeaveDays;
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
