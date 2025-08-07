class EmployeeCurrentShiftEntity {
  final String? currentDate;
  final String? currentDateNp;
  final bool? hasMultiShift;
  final int? primaryShiftTypeId;
  final int? extendedShiftTypeId;
  final String? primaryShiftName;
  final String? primaryShiftTime;
  final String? primaryShiftStart;
  final String? primaryShiftEnd;
  final String? breakEndTime;
  final String? breakStartTime;
  final String? extendedShiftName;
  final String? extendedShiftTime;
  final String? extendedShiftStart;
  final String? extendedShiftEnd;
  final int? employeeId;
  final bool? isContinuousShift;
  final bool? hasBreak;
  final bool? isFlexibleBreak;
  final String? primaryBreakDuration;

  EmployeeCurrentShiftEntity({
    this.currentDate,
    this.currentDateNp,
    this.hasMultiShift,
    this.primaryShiftTypeId,
    this.extendedShiftTypeId,
    this.primaryShiftName,
    this.primaryShiftTime,
    this.primaryShiftStart,
    this.primaryShiftEnd,
    this.breakEndTime,
    this.breakStartTime,
    this.extendedShiftName,
    this.extendedShiftTime,
    this.extendedShiftStart,
    this.extendedShiftEnd,
    this.employeeId,
    this.isContinuousShift,
    this.hasBreak,
    this.isFlexibleBreak,
    this.primaryBreakDuration,
  });
}
