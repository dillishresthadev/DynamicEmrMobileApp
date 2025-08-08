import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/branch_storage.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_contract_model.dart';
import 'package:dynamic_emr/features/profile/data/models/employee_model.dart';
import 'package:dynamic_emr/injection.dart';

abstract class EmployeeRemoteDatasource {
  Future<EmployeeModel> getEmployeeDetails();
  Future<EmployeeContractModel> getEmployeeContract();
}

class EmployeeRemoteDatasourceImpl implements EmployeeRemoteDatasource {
  final DioHttpClient client;

  EmployeeRemoteDatasourceImpl({required this.client});
  @override
  Future<EmployeeModel> getEmployeeDetails() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final workingBranchId = await injection<BranchSecureStorage>()
          .getWorkingBranchId();
      final workingFinancialYearId = await injection<BranchSecureStorage>()
          .getSelectedFiscalYearId();

      final response = await client.get(
        "$baseUrl${ApiConstants.getEmployeeDetail}",
        token: accessToken,
        headers: {
          "workingBranchId": workingBranchId.toString(),
          "workingFinancialId": workingFinancialYearId.toString(),
        },
      );

      return EmployeeModel.fromJson(response);
    } catch (e) {
      log("Error getting employee details (profile data) : $e");
      rethrow;
    }
  }

  @override
  Future<EmployeeContractModel> getEmployeeContract() {
    // TODO: implement getEmployeeContract
    throw UnimplementedError();
  }
}
