
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:dynamic_emr/features/profile/domain/repository/employee_repository.dart';

class EmployeeDetailsUsecase {
  final EmployeeRepository repository;

  EmployeeDetailsUsecase({required this.repository});

  Future<EmployeeEntity> call() async {
    return await repository.getEmployeeDetails();
  }
}
