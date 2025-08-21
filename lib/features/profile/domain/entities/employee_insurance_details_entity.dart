class EmployeeInsuranceDetailsEntity {
  final String employeeName;
  final String employeeCode;
  final bool isIncomeTaxExemptionApplicable;
  final int incomeTaxExemptionCategoryId;
  final String type;
  final String policyNumber;
  final String company;
  final DateTime insuredFromDate;
  final DateTime insuredToDate;
  final String insuredFromDateNp;
  final String insuredToDateNp;
  final double amount;
  final double maturityPeriod;
  final int countryId;
  final String countryName;
  final String firstReceiptNo;
  final DateTime firstReceiptDate;
  final String firstReceiptDateNp;

  EmployeeInsuranceDetailsEntity({
    required this.employeeName,
    required this.employeeCode,
    required this.isIncomeTaxExemptionApplicable,
    required this.incomeTaxExemptionCategoryId,
    required this.type,
    required this.policyNumber,
    required this.company,
    required this.insuredFromDate,
    required this.insuredToDate,
    required this.insuredFromDateNp,
    required this.insuredToDateNp,
    required this.amount,
    required this.maturityPeriod,
    required this.countryId,
    required this.countryName,
    required this.firstReceiptNo,
    required this.firstReceiptDate,
    required this.firstReceiptDateNp,
  });
}
