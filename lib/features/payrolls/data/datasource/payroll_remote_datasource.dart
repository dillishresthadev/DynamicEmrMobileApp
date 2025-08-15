import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/payrolls/data/models/loan_and_advance_model.dart';
import 'package:dynamic_emr/features/payrolls/data/models/salary_model.dart';
import 'package:dynamic_emr/features/payrolls/data/models/taxes_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class PayrollRemoteDatasource {
  Future<SalaryModel> getCurrentMonthSalary();
  Future<SalaryModel> getMonthlySalary(int month, int year);
  Future<LoanAndAdvanceModel> getLoanAndAdvance();
  Future<List<TaxesModel>> getTaxes();
}

class PayrollRemoteDatasourceImpl implements PayrollRemoteDatasource {
  final DioHttpClient client;

  PayrollRemoteDatasourceImpl({required this.client});

  @override
  Future<SalaryModel> getCurrentMonthSalary() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.get(
        "$baseUrl${ApiConstants.getMyCurrentMonthSalary}",
        token: accessToken,
      );
      return SalaryModel.fromJson(response);
    } catch (e) {
      log("Error getting current month salary :$e");
      rethrow;
    }
  }

  @override
  Future<SalaryModel> getMonthlySalary(int month, int year) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.post(
        "$baseUrl${ApiConstants.getMyMonthSalary}",
        token: accessToken,
        body: {"month": month, "year": year},
      );
      return SalaryModel.fromJson(response);
    } catch (e) {
      log("Error getting current month salary :$e");
      rethrow;
    }
  }

  @override
  Future<LoanAndAdvanceModel> getLoanAndAdvance() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.get(
        "$baseUrl${ApiConstants.getMyLoanAndAdvances}",
        token: accessToken,
      );
      return LoanAndAdvanceModel.fromJson(response);
    } catch (e) {
      log("Error getting loan and advances :$e");
      rethrow;
    }
  }

  @override
  Future<List<TaxesModel>> getTaxes() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getMyTaxes}",
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

      return jsonList.map((json) => TaxesModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting taxes: $e");
      rethrow;
    }
  }
}
