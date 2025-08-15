import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/notice/data/models/notice_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class NoticeRemoteDatasource {
  Future<List<NoticeModel>> getAllNotices();
  Future<NoticeModel> getNoticeById(int noticeId);
}

class NoticeRemoteDatasourceImpl extends NoticeRemoteDatasource {
  final DioHttpClient client;

  NoticeRemoteDatasourceImpl({required this.client});
  @override
  Future<List<NoticeModel>> getAllNotices() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getAllNotices}",
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
        log('Unexpected response format: $response');
      }
      return jsonList.map((json) => NoticeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting all notices $e");
      rethrow;
    }
  }

  @override
  Future<NoticeModel> getNoticeById(int noticeId) {
    // TODO: implement getNoticeById
    throw UnimplementedError();
  }
}
