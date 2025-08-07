import 'package:dynamic_emr/features/profile/domain/entities/employee_insurance_details_entity.dart';

class EmployeeInsuranceDetailsModel extends EmployeeInsuranceDetailsEntity {
  EmployeeInsuranceDetailsModel({
    super.employeeCode,
    required super.type,
    required super.enddate,
    required super.startdate,
    required super.policyNumber,
    required super.employeeName,
    required super.amount,
    required super.isIncomeTaxExceptionApplicable,
    required super.company,
  });
  factory EmployeeInsuranceDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeInsuranceDetailsModel(
      company: json['company']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      startdate: json['insuredFromDate']?.toString() ?? '',
      enddate: json['insuredToDate']?.toString() ?? '',
      policyNumber: json['policyNumber']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      isIncomeTaxExceptionApplicable:
          json['isIncomeTaxExemptionApplicable']?.toString() ?? '',
    );
  }
}
