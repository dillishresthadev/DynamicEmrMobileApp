class EmployeeContractEntity {
  final int id;
  final int employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime contractStartDate;
  final String contractStartDateNp;
  final DateTime contractEndDate;
  final String contractEndDateNp;
  final String contractType;
  final String typeOfEmploymentTitle;
  final int typeOfEmploymentId;
  final String? jobDescription;
  final String levelTitle;
  final String gradeNo;
  final String payPackageTitle;
  final bool? isOTAvailable;
  final double otRate;
  final double totalIncome;
  final double totalIncomeYearly;
  final String status;
  final int expireInDays;

  EmployeeContractEntity(
      {required this.id,
      required this.employeeId,
      required this.employeeName,
      required this.employeeCode,
      required this.contractStartDate,
      required this.contractStartDateNp,
      required this.contractEndDate,
      required this.contractEndDateNp,
      required this.contractType,
      required this.typeOfEmploymentTitle,
      required this.typeOfEmploymentId,
      required this.jobDescription,
      required this.levelTitle,
      required this.gradeNo,
      required this.payPackageTitle,
      required this.isOTAvailable,
      required this.otRate,
      required this.totalIncome,
      required this.totalIncomeYearly,
      required this.status,
      required this.expireInDays});
}
