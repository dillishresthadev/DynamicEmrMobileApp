import 'package:dynamic_emr/features/profile/domain/entities/employee_current_shift_entity.dart';

class EmployeeCurrentShiftModel extends EmployeeCurrentShiftEntity {
  EmployeeCurrentShiftModel({
    super.currentDate,
    super.currentDateNp,
    super.hasMultiShift,
    super.primaryShiftTypeId,
    super.extendedShiftTypeId,
    super.primaryShiftName,
    super.primaryShiftTime,
    super.primaryShiftStart,
    super.primaryShiftEnd,
    super.breakEndTime,
    super.breakStartTime,
    super.extendedShiftName,
    super.extendedShiftTime,
    super.extendedShiftStart,
    super.extendedShiftEnd,
    super.employeeId,
    super.isContinuousShift,
    super.hasBreak,
    super.isFlexibleBreak,
    super.primaryBreakDuration,
  });
  // Factory method to create an instance from a JSON object
  factory EmployeeCurrentShiftModel.fromJson(Map<String, dynamic> json) {
    return EmployeeCurrentShiftModel(
      currentDate: json['currentDate'],
      currentDateNp: json['currentDateNp'],
      hasMultiShift: json['hasMultiShift'],
      primaryShiftTypeId: json['primaryShiftTypeId'],
      extendedShiftTypeId: json['extendedShiftTypeId'],
      primaryShiftName: json['primaryShiftName'],
      primaryShiftTime: json['primaryShiftTime'],
      primaryShiftStart: json['primaryShiftStart'],
      primaryShiftEnd: json['primaryShiftEnd'],
      breakEndTime: json['breakEndTime'],
      breakStartTime: json['breakStartTime'],
      extendedShiftName: json['extendedShiftName'],
      extendedShiftTime: json['extendedShiftTime'],
      extendedShiftStart: json['extendedShiftStart'],
      extendedShiftEnd: json['extendedShiftEnd'],
      employeeId: json['employeeId'],
      isContinuousShift: json['isContinuousShift'],
      hasBreak: json['hasBreak'],
      isFlexibleBreak: json['isFlexibleBreak'],
      primaryBreakDuration: json['primaryBreakDuration'],
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'currentDate': currentDate,
      'currentDateNp': currentDateNp,
      'hasMultiShift': hasMultiShift,
      'primaryShiftTypeId': primaryShiftTypeId,
      'extendedShiftTypeId': extendedShiftTypeId,
      'primaryShiftName': primaryShiftName,
      'primaryShiftTime': primaryShiftTime,
      'primaryShiftStart': primaryShiftStart,
      'primaryShiftEnd': primaryShiftEnd,
      'breakEndTime': breakEndTime,
      'breakStartTime': breakStartTime,
      'extendedShiftName': extendedShiftName,
      'extendedShiftTime': extendedShiftTime,
      'extendedShiftStart': extendedShiftStart,
      'extendedShiftEnd': extendedShiftEnd,
      'employeeId': employeeId,
      'isContinuousShift': isContinuousShift,
      'hasBreak': hasBreak,
      'isFlexibleBreak': isFlexibleBreak,
      'primaryBreakDuration': primaryBreakDuration,
    };
  }
}
