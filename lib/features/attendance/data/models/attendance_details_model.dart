import 'package:dynamic_emr/features/attendance/domain/entities/attendance_details_entity.dart';

class AttendanceDetailsModel extends AttendanceDetailsEntity {
  AttendanceDetailsModel({
    required super.attendanceDate,
    required super.attendanceDateNp,
    required super.employeeName,
    required super.departmentName,
    required super.dutyType,
    required super.shiftTitle,
    required super.shiftTime,
    required super.shiftStartTime,
    required super.shiftEndTime,
    required super.checkInTime,
    required super.checkOutTime,
    required super.breakOutTime,
    required super.breakInTime,
    required super.status,
    required super.remarks,
    required super.statusFullName,
    required super.statusColorCode,
  });

  factory AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceDetailsModel(
      attendanceDate: DateTime.parse(json['attendanceDate'] ?? ''),
      attendanceDateNp: json['attendanceDateNp'] ?? '',
      employeeName: json['employeeName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      dutyType: json['dutyType'] ?? '',
      shiftTitle: json['shiftTitle'] ?? '',
      shiftTime: json['shiftTime'] ?? '',
      shiftStartTime: DateTime.parse(json['shiftStartTime'] ?? ''),
      shiftEndTime: DateTime.parse(json['shiftEndTime'] ?? ''),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] ?? '')
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] ?? '')
          : null,
      breakOutTime: json['breakOutTime'] != null
          ? DateTime.parse(json['breakOutTime'] ?? '')
          : null,
      breakInTime: json['breakInTime'] != null
          ? DateTime.parse(json['breakInTime'] ?? '')
          : null,
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      statusFullName: json['statusFullName'] ?? '',
      statusColorCode: json['statusColorCode'] ?? '',
    );
  }
}
