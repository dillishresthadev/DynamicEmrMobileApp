import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';

class MonthlySalaryUsecase {
  final PayrollRepository repository;

  MonthlySalaryUsecase({required this.repository});

  Future<SalaryEntity> call(int month, int year) async {
    return await repository.getMonthlySalary(month, year);
  }
}
