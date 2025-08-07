class EmployeeInsuranceDetailsEntity {
  final String? employeeCode;
  final String type;
  final String enddate;
  final String startdate;
  final String policyNumber;
  final String employeeName;
  final String amount;
  final String isIncomeTaxExceptionApplicable;
  final String company;

  EmployeeInsuranceDetailsEntity(
      {this.employeeCode,
      required this.type,
      required this.enddate,
      required this.startdate,
      required this.policyNumber,
      required this.employeeName,
      required this.amount,
      required this.isIncomeTaxExceptionApplicable,
      required this.company});
}
