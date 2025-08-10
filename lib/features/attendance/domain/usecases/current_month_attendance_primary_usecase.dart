import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/repository/attendance_repository.dart';

class CurrentMonthAttendancePrimaryUsecase {
  final AttendanceRepository repository;

  CurrentMonthAttendancePrimaryUsecase({required this.repository});

  Future<List<AttendanceEntity>> call() async {
    return await repository.getCurrentMonthAttendancePrimary();
  }
}
