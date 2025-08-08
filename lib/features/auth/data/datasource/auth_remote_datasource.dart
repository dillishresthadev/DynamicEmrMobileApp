import 'dart:convert';
import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/auth/data/models/login_response_model.dart';
import 'package:dynamic_emr/features/auth/data/models/user_branch_model.dart';
import 'package:dynamic_emr/features/auth/data/models/user_financial_year_model.dart';
import 'package:dynamic_emr/features/auth/data/models/user_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class AuthRemoteDatasource {
  Future<String> getHospitalBaseURL(String hospitalCode);
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });

  Future<String?> refreshToken({required String refreshToken});

  Future<List<UserBranchModel>> getUserBranches();

  Future<List<UserFinancialYearModel>> getUserFinancialYears();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final DioHttpClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> getHospitalBaseURL(String hospitalCode) async {
    try {
      final response = await client.get(
        "${ApiConstants.hospitalCodeURL}/$hospitalCode",
      );
      return response['url'];
    } catch (e) {
      return "Error Getting Hospital Base URL : $e";
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final user = UserModel(username: username, password: password);
    final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

    final response = await client.post(
      "$baseUrl${ApiConstants.userLogin}",
      body: user.toJson(),
    );
    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<List<UserBranchModel>> getUserBranches() async {
    final response = await client.get(ApiConstants.getUserBranches, token: '');
    final List<dynamic> jsonList = jsonDecode(response['']);

    return jsonList.map((json) => UserBranchModel.fromJson(json)).toList();
  }

  @override
  Future<List<UserFinancialYearModel>> getUserFinancialYears() async {
    final response = await client.get(
      ApiConstants.getUserFinancialYear,
      token: '',
    );
    final List<dynamic> jsonList = jsonDecode(response['']);
    return jsonList
        .map((json) => UserFinancialYearModel.fromJson(json))
        .toList();
  }

  @override
  Future<String?> refreshToken({required String refreshToken}) async {
    try {
      final response = await client.post(
        ApiConstants.userRefreshToken,
        body: {"RefreshToken": refreshToken},
      );

      log('Refresh Token Response: $response');
      return response['token'];
    } catch (e) {
      log('Error refreshing token: $e');
      rethrow;
    }
  }
}
