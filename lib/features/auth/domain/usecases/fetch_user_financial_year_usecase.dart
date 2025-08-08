import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class FetchUserFinancialYearUsecase {
  final AuthRepository repository;

  FetchUserFinancialYearUsecase({required this.repository});

  Future<List<UserFinancialYearEntity>> call() async {
    return await repository.getUserFinancialYears();
  }
}
