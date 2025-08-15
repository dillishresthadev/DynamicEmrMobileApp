import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';

abstract class PayrollRepository {
  Future<SalaryEntity> getCurrentMonthSalary();
  Future<SalaryEntity> getMonthlySalary(int month, int year);
  Future<LoanAndAdvanceEntity> getLoanAndAdvance();
  Future<List<TaxesEntity>> getTaxes();
}
