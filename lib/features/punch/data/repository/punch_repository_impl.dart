import 'package:dynamic_emr/features/punch/data/datasource/punch_remote_datasource.dart';
import 'package:dynamic_emr/features/punch/domain/entities/employee_punch_entity.dart';
import 'package:dynamic_emr/features/punch/domain/repository/punch_repository.dart';

class PunchRepositoryImpl extends PunchRepository {
  final PunchRemoteDatasource remoteDatasource;

  PunchRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<EmployeePunchEntity>> getTodayPunches() async {
    return await remoteDatasource.getEmployeePunches();
  }

  @override
  Future<bool> postTodayPunch(String longitude, String latitude) async {
    return await remoteDatasource.employeePunch(longitude, latitude);
  }
}
