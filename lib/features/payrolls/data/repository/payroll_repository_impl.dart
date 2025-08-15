import 'package:dynamic_emr/features/payrolls/data/datasource/payroll_remote_datasource.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';

class PayrollRepositoryImpl extends PayrollRepository {
  final PayrollRemoteDatasource remoteDatasource;

  PayrollRepositoryImpl({required this.remoteDatasource});
  @override
  Future<SalaryEntity> getCurrentMonthSalary() async {
    return await remoteDatasource.getCurrentMonthSalary();
  }

  @override
  Future<LoanAndAdvanceEntity> getLoanAndAdvance() async {
    return await remoteDatasource.getLoanAndAdvance();
  }

  @override
  Future<SalaryEntity> getMonthlySalary(int month, int year) async {
    return await remoteDatasource.getMonthlySalary(month, year);
  }

  @override
  Future<List<TaxesEntity>> getTaxes() async {
    return await remoteDatasource.getTaxes();
  }
}
