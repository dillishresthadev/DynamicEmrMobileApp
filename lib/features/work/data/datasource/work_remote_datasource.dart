import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/work/data/models/business_client_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_categories_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_details_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_model.dart';
import 'package:dynamic_emr/features/work/data/models/ticket_summary_model.dart';
import 'package:dynamic_emr/features/work/data/models/work_user_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class WorkRemoteDatasource {
  Future<TicketSummaryModel> getMyTicketSummary();
  Future<TicketSummaryModel> getTicketAssignedToMeSummary();
  Future<TicketDetailsModel> getTicketDetailsById({required int ticketId});
  Future<List<WorkUserModel>> getWorkUserList();
  Future<bool> closeTicket(int ticketId);
  Future<bool> reOpenTicket(int ticketId);
  Future<bool> commentOnTicket(
    int ticketId,
    String message,
    List<String>? attachmentPaths,
  );
  Future<List<TicketCategoriesModel>> getTicketCategories();
  Future<bool> createNewTicket(
    String ticketDate,
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    int clientId,
    String client,
    String clientDesc,
    String clientDesc2,
    String dueDate,
    int assignToEmployeeId,
    int issueByEmployeeId,
    List<String>? attachmentPaths,
  );

  Future<List<TicketModel>> getFilteredMyTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    int clientId,
    String clientDesc,
    String clientDesc2,
    String fromDate,
    String toDate,
    String orderBy,
  );
  Future<List<TicketModel>> getFilteredMyAssignedTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    int clientId,
    String clientDesc,
    String clientDesc2,
    String fromDate,
    String toDate,
    String orderBy,
  );
  Future<bool> editPriority(int ticketId, String status);
  Future<bool> editSeverity(int ticketId, String status);
  Future<bool> editAssignTo(int ticketId, int assignedUserId);
  Future<bool> editTicket({
    required int id,
    required String title,
    required String description,
    required String ticketDate,
    required String severity,
    required String priority,
    required int ticketCategoryId,
    // required String ticketCategoryName,
    required int assignToEmployeeId,
    // required String assignedTo,
    required DateTime assignedOn,
    required String issueByEmployeeId,
    // required String issueBy,
    required DateTime issueOn,
    required String sessionTag,
    required int clientId,
    required String clients,
    required String clientDesc,
    required String clientDesc2,
    required String? dueDate,
    required List<dynamic> attachmentFiles,
    required List<String> attachedDocuments,
  });

  Future<List<BusinessClientModel>> getBusinessClient();
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
    String ticketDate,
    int ticketCategoryId,
    String title,
    String description,
    String severity,
    String priority,
    int clientId,
    String clientName,
    String clientDesc,
    String clientDesc2,
    String dueDate,
    int assignToEmployeeId,
    int issueByEmployeeId,
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
            .map(
              (path) => MultipartFile.fromFileSync(
                path,
                filename: path.split('/').last,
                contentType: DioMediaType('application', 'octet-stream'),
              ),
            )
            .toList();
      }

      log("[Datasource] Files : ${files?.first.filename} ");
      final formData = FormData.fromMap({
        "TicketDate": ticketDate,
        "TicketCategoryId": ticketCategoryId,
        "Title": title,
        "Description": description,
        "Severity": severity,
        "Priority": priority,
        "ClientId": clientId,
        "Client": clientName,
        "ClientDesc": clientDesc,
        "ClientDesc2": clientDesc2,
        "DueDate": dueDate,
        "IssueByEmployeeId": issueByEmployeeId,
        "AssignToEmployeeId": assignToEmployeeId,
        "AttachmentFiles": files,
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

  @override
  Future<List<TicketModel>> getFilteredMyAssignedTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    int clientId,
    String clientDesc,
    String clientDesc2,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.post(
        "$baseUrl/${ApiConstants.myTicket}",
        token: accessToken,
        body: {
          "CategoryId": ticketCategoryId,
          "Status": status,
          "Priority": priority,
          "Severity": severity,
          "AssignedTo": assignTo,
          "ClientId": clientId,
          "ClientDesc": clientDesc,
          "ClientDesc2": clientDesc2,
          "FromDate": fromDate,
          "ToDate": toDate,
          "OrderBy": orderBy,
        },
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
      return jsonList.map((json) => TicketModel.fromJson(json)).toList();
    } catch (e) {
      log("Error filter myTicket: $e");
      rethrow;
    }
  }

  @override
  Future<List<TicketModel>> getFilteredMyTickets(
    int ticketCategoryId,
    String status,
    String priority,
    String severity,
    String assignTo,
    int clientId,
    String clientDesc,
    String clientDesc2,
    String fromDate,
    String toDate,
    String orderBy,
  ) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.post(
        "$baseUrl/${ApiConstants.ticketAssignedToMe}",
        token: accessToken,
        body: {
          "CategoryId": ticketCategoryId,
          "Status": status,
          "Priority": priority,
          "Severity": severity,
          "AssignedTo": assignTo,
          "ClientId": clientId,
          "ClientDesc": clientDesc,
          "ClientDesc2": clientDesc2,
          "FromDate": fromDate,
          "ToDate": toDate,
          "OrderBy": orderBy,
        },
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
      return jsonList.map((json) => TicketModel.fromJson(json)).toList();
    } catch (e) {
      log("Error filter ticketAssignedToMe: $e");
      rethrow;
    }
  }

  @override
  Future<bool> closeTicket(int ticketId) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.closeTicket}/$ticketId",
        token: accessToken,
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
      log("Error while closing ticket : $e");
      rethrow;
    }
  }

  @override
  Future<bool> reOpenTicket(int ticketId) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.reOpenTicket}/$ticketId",
        token: accessToken,
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
      log("Error while reopening ticket : $e");
      rethrow;
    }
  }

  @override
  Future<bool> commentOnTicket(
    int ticketId,
    String message,
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
            .map(
              (path) => MultipartFile.fromFileSync(
                path,
                filename: path.split('/').last,
                contentType: DioMediaType('application', 'octet-stream'),
              ),
            )
            .toList();
      }
      final formData = FormData.fromMap({
        "TicketId": ticketId,
        "Comment": message,
        "AttachmentFiles": files,
      });

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.commentPost}/$ticketId",
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
      log("Error while reopening ticket : $e");
      rethrow;
    }
  }

  @override
  Future<bool> editAssignTo(int ticketId, int assignedUserId) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.editAssignedTo}",
        token: accessToken,
        body: {"Id": ticketId, "AssignToId": assignedUserId},

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
      log("Error while editing assigned to : $e");
      rethrow;
    }
  }

  @override
  Future<bool> editPriority(int ticketId, String status) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.editPriority}",
        token: accessToken,
        body: {"Id": ticketId, "StatusValue": status},

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
      log("Error while editing priority : $e");
      rethrow;
    }
  }

  @override
  Future<bool> editSeverity(int ticketId, String status) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.editSeverity}",
        token: accessToken,
        body: {"Id": ticketId, "StatusValue": status},

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
      log("Error while editing severity : $e");
      rethrow;
    }
  }

  @override
  Future<List<BusinessClientModel>> getBusinessClient() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.businessClient}",
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
      return jsonList
          .map((json) => BusinessClientModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting businessClient: $e");
      rethrow;
    }
  }

  @override
  Future<bool> editTicket({
    required int id,
    required String title,
    required String description,
    required String ticketDate,
    required String severity,
    required String priority,
    required int ticketCategoryId,
    required int assignToEmployeeId,
    required DateTime assignedOn,
    required String issueByEmployeeId,
    required DateTime issueOn,
    required String sessionTag,
    required int clientId,
    required String clients,
    required String clientDesc,
    required String clientDesc2,
    required String? dueDate,
    required List attachmentFiles,
    required List<String> attachedDocuments,
  }) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      // Convert attachedDocuments to MultipartFile list
      List<MultipartFile>? files;
      if (attachedDocuments.isNotEmpty) {
        files = attachedDocuments
            .map(
              (path) => MultipartFile.fromFileSync(
                path,
                filename: path.split('/').last,
                contentType: DioMediaType('application', 'octet-stream'),
              ),
            )
            .toList();
      }

      // Dynamically build the form data map
      final Map<String, dynamic> dataMap = {};

      void addIfNotEmpty(String key, dynamic value) {
        if (value == null) return;
        if (value is String && value.trim().isEmpty) return;
        dataMap[key] = value;
      }

      // Required fields
      dataMap["Id"] = id;
      addIfNotEmpty("Title", title);
      addIfNotEmpty("Description", description);
      addIfNotEmpty("TicketDate", ticketDate);
      addIfNotEmpty("Severity", severity);
      addIfNotEmpty("Priority", priority);
      dataMap["TicketCategoryId"] = ticketCategoryId;
      dataMap["AssignToEmployeeId"] = assignToEmployeeId;
      addIfNotEmpty("IssueByEmployeeId", issueByEmployeeId);
      // addIfNotEmpty("SessionTag", sessionTag);
      dataMap["ClientId"] = clientId;
      addIfNotEmpty("Client", clients);
      addIfNotEmpty("ClientDesc", clientDesc);
      addIfNotEmpty("ClientDesc2", clientDesc2);
      addIfNotEmpty("DueDate", dueDate);
      if (attachmentFiles.isNotEmpty) {
        dataMap["AttachmentFiles"] = attachmentFiles;
      }
      if (files != null && files.isNotEmpty) {
        dataMap["AttachedDocuments"] = files;
      }

      final formData = FormData.fromMap(dataMap);

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.editTicket}",
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
      log("Error editing ticket: $e");
      rethrow;
    }
  }
}
