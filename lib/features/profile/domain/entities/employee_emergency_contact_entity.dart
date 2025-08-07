class EmployeeEmergencyContactEntity {
  final int id;
  final int employeeId;
  final String contactPerson;
  final String phoneNumber;
  final String relation;
  final String? employeeName;
  final String? employeeCode;

  EmployeeEmergencyContactEntity(
      {required this.id,
      required this.employeeId,
      required this.contactPerson,
      required this.phoneNumber,
      required this.relation,
      required this.employeeName,
      required this.employeeCode});
}
