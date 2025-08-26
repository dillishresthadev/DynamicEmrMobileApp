import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/Leave/data/models/leave_application_model.dart';
import 'package:dynamic_emr/features/Leave/data/models/leave_application_request_model.dart';
import 'package:dynamic_emr/features/Leave/data/models/leave_history_model.dart';
import 'package:dynamic_emr/features/Leave/data/models/leave_type_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class LeaveRemoteDatasource {
  Future<List<LeaveHistoryModel>> getLeaveHistory();
  Future<List<LeaveApplicationModel>> getLeaveApplicationHistory();
  Future<List<LeaveApplicationModel>> getApprovedLeaveList();
  Future<List<LeaveApplicationModel>> getPendingLeaveList();
  Future<bool> applyLeave(LeaveApplicationRequestModel leaveRequest);

  Future<List<LeaveTypeModel>> getLeaveType();
  Future<List<LeaveTypeModel>> getExtendedLeaveType();
  Future<List<LeaveTypeModel>> getSubstitutionLeaveEmployee();

  Future<List<LeaveTypeModel>> getContractList();
  Future<List<LeaveTypeModel>> getFiscalYearByContractId(int contractId);
  Future<List<LeaveHistoryModel>> getLeaveHistoryByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  );
  Future<List<LeaveApplicationModel>> getLeavesByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  );
}

class LeaveRemoteDatasourceImpl implements LeaveRemoteDatasource {
  final DioHttpClient client;

  LeaveRemoteDatasourceImpl({required this.client});
  @override
  Future<List<LeaveApplicationModel>> getLeaveApplicationHistory() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.employeeLeaves}",
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
          .map((json) => LeaveApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting leave application history: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveHistoryModel>> getLeaveHistory() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.getEmployeeLeaveHistory}",
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

      return jsonList.map((json) => LeaveHistoryModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting leave history: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveApplicationModel>> getApprovedLeaveList() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.approvedEmployeeLeavesToCome}",
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
          .map((json) => LeaveApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting leave history: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveApplicationModel>> getPendingLeaveList() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final dynamic response = await client.get(
        "$baseUrl${ApiConstants.pendingEmployeeLeavesToCome}",
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
          .map((json) => LeaveApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting leave history: $e");
      rethrow;
    }
  }

  @override
  Future<bool> applyLeave(LeaveApplicationRequestModel leaveRequest) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final rawResponse = await client.post(
        "$baseUrl/${ApiConstants.leaveApplicationPost}",
        token: accessToken,
        body: leaveRequest.toJson(),
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
      log("Error getting while applying leave: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveTypeModel>> getExtendedLeaveType() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getExtendedLeaveTypes}",
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

      return jsonList.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting extended leave type: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveTypeModel>> getLeaveType() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getLeaveTypes}",
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

      return jsonList.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting leave type: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveTypeModel>> getSubstitutionLeaveEmployee() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getSubstitutionEmployee}",
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

      return jsonList.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting substitute employee: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveTypeModel>> getContractList() async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getContracts}",
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

      return jsonList.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting contracts list: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveTypeModel>> getFiscalYearByContractId(int contractId) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.getContractFiscalYearByContctId}/$contractId",
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

      return jsonList.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting contracts list: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveHistoryModel>> getLeaveHistoryByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  ) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.employeeLeaveHistoryByContractIdAndFiscalYearId}/$contractId/$fiscalYearId",
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

      return jsonList.map((json) => LeaveHistoryModel.fromJson(json)).toList();
    } catch (e) {
      log("Error getting leave history contractId fiscalYear Id list: $e");
      rethrow;
    }
  }

  @override
  Future<List<LeaveApplicationModel>> getLeavesByContractIdAndFiscalYearId(
    int contractId,
    int fiscalYearId,
  ) async {
    try {
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();
      final dynamic response = await client.get(
        "$baseUrl/${ApiConstants.employeeLeavesByContractIdAndFiscalYearId}/$contractId/$fiscalYearId",
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
          .map((json) => LeaveApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Error getting leaves application history list: $e");
      rethrow;
    }
  }
}
