import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/repository/payroll_repository.dart';

class LoanAndAdvanceUsecase {
  final PayrollRepository repository;

  LoanAndAdvanceUsecase({required this.repository});

  Future<LoanAndAdvanceEntity> call() async {
    return await repository.getLoanAndAdvance();
  }
}
