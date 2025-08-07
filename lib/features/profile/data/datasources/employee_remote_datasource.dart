import 'package:dynamic_emr/features/profile/data/models/employee_contract_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_model.dart';

abstract class EmployeeRemoteDatasource {
  Future<EmployeeModel> getEmployeeDetails();
  Future<EmployeeContractModel> getEmployeeContract();
}

class EmployeeRemoteDatasourceImpl implements EmployeeRemoteDatasource {
  @override
  Future<EmployeeModel> getEmployeeDetails() {
    // TODO: implement getEmployeeDetails
    throw UnimplementedError();
  }

  @override
  Future<EmployeeContractModel> getEmployeeContract() {
    // TODO: implement getEmployeeContract
    throw UnimplementedError();
  }
}
