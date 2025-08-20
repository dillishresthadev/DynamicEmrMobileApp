import 'package:dynamic_emr/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<String> getHospitalBaseUrl({required String hospitalCode}) async {
    final url = await remoteDataSource.getHospitalBaseURL(hospitalCode);
    return url;
  }

  @override
  Future<LoginResponseEntity> login({
    required String username,
    required String password,
  }) async {
    final loginResponse = await remoteDataSource.login(
      username: username,
      password: password,
    );

    return loginResponse;
  }

  @override
  Future<List<HospitalBranchEntity>> getUserBranches() async {
    final branchData = await remoteDataSource.getUserBranches();
    return branchData;
  }

  @override
  Future<List<UserFinancialYearEntity>> getUserFinancialYears() async {
    final financialYearData = await remoteDataSource.getUserFinancialYears();
    return financialYearData;
  }

  @override
  Future<LoginResponseEntity> refreshToken({
    required String refreshToken,
  }) async {
    final loginResponse = await remoteDataSource.refreshToken(
      refreshToken: refreshToken,
    );
    return loginResponse;
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
