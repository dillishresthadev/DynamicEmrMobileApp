import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/auth/data/models/login_response_model.dart';
import 'package:dynamic_emr/features/auth/data/models/hospital_branch_model.dart';
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

  Future<List<HospitalBranchModel>> getUserBranches();

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
      log("Error Getting Hospital Base URL: $e");
      rethrow;
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = UserModel(username: username, password: password);
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      log("Saved Base URL : $baseUrl");

      final response = await client.post(
        "$baseUrl${ApiConstants.userLogin}",
        body: user.toJson(),
      );

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      log("Error during login: $e");
      rethrow;
    }
  }

  @override
  Future<List<HospitalBranchModel>> getUserBranches() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      log("Access Token : $accessToken");

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getUserBranches}",
        token: accessToken,
      );

      List<dynamic> jsonList;

      if (response is List) {
        jsonList = response;
      } else if (response is Map<String, dynamic>) {
        jsonList = response['data'];
      } else {
        jsonList = [];
        log('Unexpected response format: $response');
      }

      return jsonList
          .map((json) => HospitalBranchModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting user branches: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserFinancialYearModel>> getUserFinancialYears() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final dynamic response = await client.get(
        ApiConstants.getUserFinancialYear,
        token: accessToken,
      );
      List<dynamic> jsonList;
      if (response is List) {
        jsonList = response;
      } else if (response is Map<String, dynamic>) {
        jsonList = response['data'];
      } else {
        jsonList = [];
        log('Unexpected response format: $response');
      }
      return jsonList
          .map((json) => UserFinancialYearModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting financial years: $e");
      rethrow;
    }
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
