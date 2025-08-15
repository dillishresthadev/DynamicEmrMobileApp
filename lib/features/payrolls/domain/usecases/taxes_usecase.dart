import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';

class TaxesUsecase {
  final PayrollRepository repository;

  TaxesUsecase({required this.repository});

  Future<List<TaxesEntity>> call() async {
    return await repository.getTaxes();
  }
}
