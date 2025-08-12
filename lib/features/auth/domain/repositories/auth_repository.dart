import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';

abstract class AuthRepository {
  Future<String> getHospitalBaseUrl({required String hospitalCode});
  Future<LoginResponseEntity> login({
    required String username,
    required String password,
  });
  Future<void> logout();
  Future<LoginResponseEntity?> refreshToken({required String refreshToken});
  Future<List<HospitalBranchEntity>> getUserBranches();
  Future<List<UserFinancialYearEntity>> getUserFinancialYears();
}
