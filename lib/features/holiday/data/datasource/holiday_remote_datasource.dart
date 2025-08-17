import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/holiday/data/models/holiday_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class HolidayRemoteDatasource {
  Future<List<HolidayModel>> getAllHolidayList();
  Future<List<HolidayModel>> getPastHolidayList();
  Future<List<HolidayModel>> getUpcommingHolidayList();
}

class HolidayRemoteDatasourceImpl implements HolidayRemoteDatasource {
  final DioHttpClient client;

  HolidayRemoteDatasourceImpl({required this.client});
  @override
  Future<List<HolidayModel>> getAllHolidayList() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getHolidayList}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      List<dynamic> jsonList = [];

      if (response is List) {
        jsonList = response;
      } else if (response is Map<String, dynamic>) {
        jsonList = response['data'];
      } else {
        jsonList = [];
        log("Unstructured data formate $response");
      }

      return jsonList.map((json) => HolidayModel.fromJson(json)).toList();
    } catch (e) {
      log("Error occure while getting holiday list:$e");
      rethrow;
    }
  }

  @override
  Future<List<HolidayModel>> getPastHolidayList() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getPastHolidayList}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      List<dynamic> jsonList = [];

      if (response is List) {
        jsonList = response;
      } else if (response is Map<String, dynamic>) {
        jsonList = response['data'];
      } else {
        jsonList = [];
        log("Unstructured data formate $response");
      }

      return jsonList.map((json) => HolidayModel.fromJson(json)).toList();
    } catch (e) {
      log("Error occure while getting past holiday list:$e");
      rethrow;
    }
  }

  @override
  Future<List<HolidayModel>> getUpcommingHolidayList() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getUpcommingHolidayList}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      List<dynamic> jsonList = [];

      if (response is List) {
        jsonList = response;
      } else if (response is Map<String, dynamic>) {
        jsonList = response['data'];
      } else {
        jsonList = [];
        log("Unstructured data formate $response");
      }

      return jsonList.map((json) => HolidayModel.fromJson(json)).toList();
    } catch (e) {
      log("Error occure while getting upcomming holiday list:$e");
      rethrow;
    }
  }
}
