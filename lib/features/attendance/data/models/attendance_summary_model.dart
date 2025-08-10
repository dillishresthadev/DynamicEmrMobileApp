import 'package:dynamic_emr/features/attendance/data/models/attendance_details_model.dart';
import 'package:dynamic_emr/features/attendance/data/models/attendance_filter_model.dart';
import 'package:dynamic_emr/features/attendance/data/models/attendance_model.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';

class AttendanceSummaryModel extends AttendenceSummaryEntity {
  AttendanceSummaryModel({
    required super.attendanceFilter,
    required super.attendanceSummary,
    required super.attendanceDetails,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      attendanceFilter: AttendanceFilterModel.fromJson(json['filter']),

      attendanceSummary: (json['attendanceSummary'] is List)
          ? (json['attendanceSummary'] as List)
                .map((e) => AttendanceModel.fromJson(e))
                .toList()
          : [],

      attendanceDetails: (json['attendanceDetails'] is List)
          ? (json['attendanceDetails'] as List)
                .map((e) => AttendanceDetailsModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
