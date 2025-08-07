import 'dart:convert';

import 'package:dynamic_emr/features/profile/domain/entities/employee_contract_entity.dart';


class EmployeeContractModel extends EmployeeContractEntity {
  EmployeeContractModel(
      {required super.id,
      required super.employeeId,
      required super.employeeName,
      required super.employeeCode,
      required super.contractStartDate,
      required super.contractStartDateNp,
      required super.contractEndDate,
      required super.contractEndDateNp,
      required super.contractType,
      required super.typeOfEmploymentTitle,
      required super.typeOfEmploymentId,
      required super.jobDescription,
      required super.levelTitle,
      required super.gradeNo,
      required super.payPackageTitle,
      required super.isOTAvailable,
      required super.otRate,
      required super.totalIncome,
      required super.totalIncomeYearly,
      required super.status,
      required super.expireInDays});
  factory EmployeeContractModel.fromJson(Map<String, dynamic> json) {
    return EmployeeContractModel(
      id: json['id'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      employeeCode: json['employeeCode'],
      contractStartDate: DateTime.parse(json['contractStartDate']),
      contractStartDateNp: json['contractStartDateNp'],
      contractEndDate: DateTime.parse(json['contractEndDate']),
      contractEndDateNp: json['contractEndDateNp'],
      contractType: json['contractType'],
      typeOfEmploymentTitle: json['typeOfEmploymentTitle'],
      typeOfEmploymentId: json['typeOfEmploymentId'],
      jobDescription: json['jobDescription'],
      levelTitle: json['levelTitle'],
      gradeNo: json['gradeNo'],
      payPackageTitle: json['payPackageTitle'],
      isOTAvailable: json['isOTAvailable'],
      otRate: (json['otRate'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalIncomeYearly: (json['totalIncomeYearly'] as num).toDouble(),
      status: json['status'],
      expireInDays: json['expireInDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
      'contractStartDate': contractStartDate.toIso8601String(),
      'contractStartDateNp': contractStartDateNp,
      'contractEndDate': contractEndDate.toIso8601String(),
      'contractEndDateNp': contractEndDateNp,
      'contractType': contractType,
      'typeOfEmploymentTitle': typeOfEmploymentTitle,
      'typeOfEmploymentId': typeOfEmploymentId,
      'jobDescription': jobDescription,
      'levelTitle': levelTitle,
      'gradeNo': gradeNo,
      'payPackageTitle': payPackageTitle,
      'isOTAvailable': isOTAvailable,
      'otRate': otRate,
      'totalIncome': totalIncome,
      'totalIncomeYearly': totalIncomeYearly,
      'status': status,
      'expireInDays': expireInDays,
    };
  }

  // Convert JSON list to a list of EmployeeContract objects
  static List<EmployeeContractModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => EmployeeContractModel.fromJson(e)).toList();
  }

  // Convert a list of EmployeeContract objects to JSON string
  static String toJsonList(List<EmployeeContractModel> contracts) {
    final List<Map<String, dynamic>> jsonList =
        contracts.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }
}
