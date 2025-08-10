import 'package:dynamic_emr/features/attendance/domain/entities/attendance_filter_entity.dart';

class AttendanceFilterModel extends AttendanceFilterEntity {
  AttendanceFilterModel({
    required super.fromDate,
    required super.toDate,
    required super.shiftType,
  });

  factory AttendanceFilterModel.fromJson(Map<String, dynamic> json) {
    return AttendanceFilterModel(
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      shiftType: json['shiftType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'shiftType': shiftType,
    };
  }
}
