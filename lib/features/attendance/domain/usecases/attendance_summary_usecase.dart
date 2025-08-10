import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/repository/attendance_repository.dart';

class AttendanceSummaryUsecase {
  final AttendanceRepository repository;

  AttendanceSummaryUsecase({required this.repository});
  Future<AttendenceSummaryEntity> call({
    required DateTime fromDate,
    required DateTime toDate,
    required String shiftType,
  }) async {
    return await repository.getAttendanceSummary(
      fromDate: fromDate,
      toDate: toDate,
      shiftType: shiftType,
    );
  }
}
