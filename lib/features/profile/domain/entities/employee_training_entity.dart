class EmployeeTrainingEntity {
  final int id;
  final int employeeId;
  final String title;
  final String fromDate;
  final String toDate;
  final String fromDateNp;
  final String toDateNp;
  final String institute;
  final String country;
  final String majorSubject;
  final bool isSponsored;
  final String? sponsoredBy;
  final String? employeeName;
  final String remarks;
  final String participationType;
  final String? employeeCode;
  final String? attachments;

  EmployeeTrainingEntity(
      {required this.id,
      required this.employeeId,
      required this.title,
      required this.fromDate,
      required this.toDate,
      required this.fromDateNp,
      required this.toDateNp,
      required this.institute,
      required this.country,
      required this.majorSubject,
      required this.isSponsored,
      required this.sponsoredBy,
      required this.employeeName,
      required this.remarks,
      required this.participationType,
      required this.employeeCode,
      required this.attachments});
}
