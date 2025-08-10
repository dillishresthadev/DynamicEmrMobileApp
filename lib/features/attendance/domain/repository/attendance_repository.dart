import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getCurrentMonthAttendancePrimary();
  Future<List<AttendanceEntity>> getCurrentMonthAttendanceExtended();
  Future<List<AttendenceSummaryEntity>> getAttendanceSummary({
    required DateTime fromDate,
    required DateTime toDate,
    required String shiftType,
  });
}
