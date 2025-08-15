import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';

class CurrentMonthSalaryUsecase {
  final PayrollRepository repository;

  CurrentMonthSalaryUsecase({required this.repository});

  Future<SalaryEntity> call() async {
    return await repository.getCurrentMonthSalary();
  }
}
