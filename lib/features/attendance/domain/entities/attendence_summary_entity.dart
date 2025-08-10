import 'package:dynamic_emr/features/attendance/domain/entities/attendance_details_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendance_filter_entity.dart';

class AttendenceSummaryEntity {
  final AttendanceFilterEntity attendanceFilter;
  final List<AttendanceEntity> attendanceSummary;
  final List<AttendanceDetailsEntity> attendanceDetails;

  AttendenceSummaryEntity({
    required this.attendanceFilter,
    required this.attendanceSummary,
    required this.attendanceDetails,
  });
}
