import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/attendance/data/models/attendance_model.dart';
import 'package:dynamic_emr/features/attendance/data/models/attendance_summary_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class AttendanceRemoteDatasource {
  Future<List<AttendanceModel>> getCurrentMonthAttendancePrimary();
  Future<List<AttendanceModel>> getCurrentMonthAttendanceExtended();
  Future<List<AttendanceSummaryModel>> getAttendanceSummary();
}

class AttendanceRemoteDatasourceImpl extends AttendanceRemoteDatasource {
  final DioHttpClient client;

  AttendanceRemoteDatasourceImpl({required this.client});

  @override
  Future<List<AttendanceModel>> getCurrentMonthAttendanceExtended() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getCurrentMonthAttendanceSheetExtended}",
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
      return jsonList.map((json) => AttendanceModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting attendance of current month (Extended) :$e");
      rethrow;
    }
  }

  @override
  Future<List<AttendanceModel>> getCurrentMonthAttendancePrimary() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getCurrentMonthAttendanceSheetPrimary}",
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
      return jsonList.map((json) => AttendanceModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting attendance of current month (Primary) :$e");
      rethrow;
    }
  }

  @override
  Future<List<AttendanceSummaryModel>> getAttendanceSummary() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getMyAttendanceSummary}",
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
          .map((json) => AttendanceSummaryModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting attendance summary :$e");
      rethrow;
    }
  }
}
