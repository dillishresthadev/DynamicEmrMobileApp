import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/repository/attendance_repository.dart';

class CurrentMonthAttendanceExtendedUsecase {
  final AttendanceRepository repository;

  CurrentMonthAttendanceExtendedUsecase({required this.repository});
  Future<List<AttendanceEntity>> call() async {
    return await repository.getCurrentMonthAttendanceExtended();
  }
}
