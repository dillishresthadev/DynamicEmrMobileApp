import 'package:dynamic_emr/features/profile/domain/entities/employee_insurance_details_entity.dart';

class EmployeeInsuranceDetailsModel extends EmployeeInsuranceDetailsEntity {
  EmployeeInsuranceDetailsModel({
    required super.employeeName,
    required super.employeeCode,
    required super.isIncomeTaxExemptionApplicable,
    required super.incomeTaxExemptionCategoryId,
    required super.type,
    required super.policyNumber,
    required super.company,
    required super.insuredFromDate,
    required super.insuredToDate,
    required super.insuredFromDateNp,
    required super.insuredToDateNp,
    required super.amount,
    required super.maturityPeriod,
    required super.countryId,
    required super.countryName,
    required super.firstReceiptNo,
    required super.firstReceiptDate,
    required super.firstReceiptDateNp,
  });

  factory EmployeeInsuranceDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeInsuranceDetailsModel(
      employeeName: json['employeeName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      isIncomeTaxExemptionApplicable:
          json['isIncomeTaxExemptionApplicable'] ?? false,
      incomeTaxExemptionCategoryId: json['incomeTaxExemptionCategoryId'] ?? 0,
      type: json['type'] ?? '',
      policyNumber: json['policyNumber'] ?? '',
      company: json['company'] ?? '',
      insuredFromDate:
          DateTime.tryParse(json['insuredFromDate'] ?? '') ?? DateTime.now(),
      insuredToDate:
          DateTime.tryParse(json['insuredToDate'] ?? '') ?? DateTime.now(),
      insuredFromDateNp: json['insuredFromDateNp'] ?? '',
      insuredToDateNp: json['insuredToDateNp'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      maturityPeriod: (json['maturityPeriod'] ?? 0).toDouble(),
      countryId: json['countryId'] ?? 0,
      countryName: json['countryName'] ?? '',
      firstReceiptNo: json['firstReceiptNo'] ?? '',
      firstReceiptDate:
          DateTime.tryParse(json['firstReceiptDate'] ?? '') ?? DateTime.now(),
      firstReceiptDateNp: json['firstReceiptDateNp'] ?? '',
    );
  }
}
