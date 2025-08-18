import 'package:dynamic_emr/features/punch/domain/entities/employee_punch_entity.dart';
import 'package:dynamic_emr/features/punch/domain/repository/punch_repository.dart';

class GetEmployeePunchListUsecase {
  final PunchRepository repository;

  GetEmployeePunchListUsecase({required this.repository});

  Future<List<EmployeePunchEntity>> call() async {
    return await repository.getTodayPunches();
  }
}
