import 'dart:developer';

import 'package:dynamic_emr/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:dynamic_emr/features/auth/domain/entities/login_response_entity.dart';
import 'package:dynamic_emr/features/auth/domain/entities/user_branch_entity.dart';
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
  Future<List<UserBranchEntity>> getUserBranches() async {
    final branchData = await remoteDataSource.getUserBranches();
    return branchData;
  }

  @override
  Future<List<UserFinancialYearEntity>> getUserFinancialYears() async {
    final financialYearData = await remoteDataSource.getUserFinancialYears();
    return financialYearData;
  }

  @override
  Future<String?> refreshToken({required String refreshToken}) async {
    try {
      final newToken = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      return newToken;
    } catch (e) {
      log('Refresh token failed: $e');
    }
    return null;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
