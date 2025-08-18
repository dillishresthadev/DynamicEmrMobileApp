import 'package:dynamic_emr/features/profile/data/datasources/employee_remote_datasource.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:dynamic_emr/features/profile/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final EmployeeRemoteDatasource remoteDatasource;

  EmployeeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<EmployeeEntity> getEmployeeDetails() async {
    return await remoteDatasource.getEmployeeDetails();
  }

  @override
  Future<EmployeeContractEntity> getEmployeeContract() {
    // TODO: implement getEmployeeContract
    throw UnimplementedError();
  }

}
