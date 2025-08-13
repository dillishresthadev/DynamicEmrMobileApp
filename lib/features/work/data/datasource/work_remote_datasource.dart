import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_categories_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_details_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_summary_model.dart';
import 'package:dynamic_emr/features/work/data/models/work_user_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class WorkRemoteDatasource {
  Future<TicketSummaryModel> getMyTicketSummary();
  Future<TicketSummaryModel> getTicketAssignedToMeSummary();
  Future<TicketDetailsModel> getTicketDetailsById({required int ticketId});
  Future<List<WorkUserModel>> getWorkUserList();
  Future<List<TicketCategoriesModel>> getTicketCategories();
  Future<bool> createNewTicket(
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    int assignToEmployeeId,
    List<String>? attachmentPaths,
  );
}

class WorkRemoteDatasourceImpl implements WorkRemoteDatasource {
  final DioHttpClient client;

  WorkRemoteDatasourceImpl({required this.client});
  @override
  Future<TicketSummaryModel> getMyTicketSummary() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final response = await client.get(
        "$baseUrl/${ApiConstants.getMyTicketSummary}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      return TicketSummaryModel.fromJson(response);
    } catch (e) {
      log("Error while getting ticket summary $e");
      rethrow;
    }
  }

  @override
  Future<TicketSummaryModel> getTicketAssignedToMeSummary() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final response = await client.get(
        "$baseUrl/${ApiConstants.getTicketAssignedToMe}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      return TicketSummaryModel.fromJson(response);
    } catch (e) {
      log("Error while getting ticket assigned to me summary $e");
      rethrow;
    }
  }

  @override
  Future<List<TicketCategoriesModel>> getTicketCategories() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getTicketCategories}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
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
      return jsonList
          .map((json) => TicketCategoriesModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting ticket categories list :$e");
      rethrow;
    }
  }

  @override
  Future<TicketDetailsModel> getTicketDetailsById({
    required int ticketId,
  }) async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final response = await client.get(
        "$baseUrl/${ApiConstants.getTicketDetailsById}/$ticketId",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      return TicketDetailsModel.fromJson(response);
    } catch (e) {
      log("Error while getting ticket details by ID $e");
      rethrow;
    }
  }

  @override
  Future<List<WorkUserModel>> getWorkUserList() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getUserList}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
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
      return jsonList.map((json) => WorkUserModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting work user list :$e");
      rethrow;
    }
  }

  @override
  Future<bool> createNewTicket(
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    int assignToEmployeeId,
    List<String>? attachmentPaths,
  ) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      // Convert file paths to MultipartFile
      List<MultipartFile>? files;
      if (attachmentPaths != null && attachmentPaths.isNotEmpty) {
        files = attachmentPaths
            .map((path) => MultipartFile.fromFileSync(path))
            .toList();
      }

      final formData = FormData.fromMap({
        "TicketCategoryId": ticketCategoryId,
        "Title": title,
        "Description": description,
        "Severity": severity,
        "Priority": priority,
        "AssignToEmployeeId": assignToEmployeeId,
        "Attachments": files,
      });

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.createTicketPost}",
        token: accessToken,
        body: formData,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialId.toString(),
        },
      );

      if (rawResponse['data'] is bool) {
        return rawResponse['data'];
      }
      throw Exception("Unexpected response format");
    } catch (e) {
      log("Error creating new ticket: $e");
      rethrow;
    }
  }
}
