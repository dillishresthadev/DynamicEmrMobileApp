
import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<EmployeeEntity> getEmployeeDetails();
  Future<EmployeeContractEntity> getEmployeeContract();
}
