
import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';
import 'package:dynamic_emr/features/profile/domain/repository/employee_repository.dart';

class EmployeeContractUsecase {
  final EmployeeRepository repository;

  EmployeeContractUsecase({required this.repository});
  Future<List<EmployeeContractEntity>> call() async {
    return await repository.getEmployeeContract();
  }
}
