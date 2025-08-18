import 'package:dynamic_emr/features/punch/domain/entities/employee_punch_entity.dart';

abstract class PunchRepository {
  Future<List<EmployeePunchEntity>> getTodayPunches();
  Future<bool> postTodayPunch(String longitude, String latitude);
}
