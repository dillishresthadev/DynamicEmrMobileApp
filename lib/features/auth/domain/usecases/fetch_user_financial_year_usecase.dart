import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class FetchUserFinancialYearUsecase {
  final UserRepository repository;

  FetchUserFinancialYearUsecase({required this.repository});

  Future<List<UserFinancialYearEntity>> call() async {
    return await repository.getUserFinancialYears();
  }
}
