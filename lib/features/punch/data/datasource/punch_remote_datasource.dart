import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/punch/data/models/employee_punch_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class PunchRemoteDatasource {
  Future<List<EmployeePunchModel>> getEmployeePunches();
  Future<bool> employeePunch(String long, String lat);
}

class PunchRemoteDatasourceImpl implements PunchRemoteDatasource {
  final DioHttpClient client;

  PunchRemoteDatasourceImpl({required this.client});
  @override
  Future<bool> employeePunch(String long, String lat) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final response = await client.post(
        "$baseUrl/${ApiConstants.punchPost}",
        token: accessToken,
        body: {"Longitude": long, "Latitude": lat},
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialId.toString(),
        },
      );

      if (response['data'] is bool) {
        return response['data'];
      }
      throw Exception("Unexpected response format");
    } catch (e) {
      log("Error on today punch $e ");
      rethrow;
    }
  }

  @override
  Future<List<EmployeePunchModel>> getEmployeePunches() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getTodayPunches}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialId.toString(),
        },
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

      return jsonList.map((json) => EmployeePunchModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting employee punches: $e");
      rethrow;
    }
  }
}
