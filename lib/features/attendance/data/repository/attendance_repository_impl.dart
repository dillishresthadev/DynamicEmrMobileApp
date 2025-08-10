import 'package:dynamic_emr/features/attendance/data/datasource/attendance_remote_datasource.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/repository/attendance_repository.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceRemoteDatasource remoteDatasource;

  AttendanceRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<AttendanceEntity>> getCurrentMonthAttendanceExtended() async {
    final currentMonthAttendanceExtended = await remoteDatasource
        .getCurrentMonthAttendanceExtended();
    return currentMonthAttendanceExtended;
  }

  @override
  Future<List<AttendanceEntity>> getCurrentMonthAttendancePrimary() async {
    final currentMonthAttendancePrimary = await remoteDatasource
        .getCurrentMonthAttendancePrimary();
    return currentMonthAttendancePrimary;
  }

  @override
  Future<AttendenceSummaryEntity> getAttendanceSummary({
    required DateTime fromDate,
    required DateTime toDate,
    required String shiftType,
  }) async {
    final attendanceSummary = await remoteDatasource.getAttendanceSummary(
      fromDate,
      toDate,
      shiftType,
    );
    return attendanceSummary;
  }
}
