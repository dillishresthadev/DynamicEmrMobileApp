class EmployeeEducationEntity {
  final int id;
  final int employeeId;
  final String school;
  final String qualification;
  final String level;
  final String yearOfPassing;
  final String yearOfPassingNp;
  final String percentageOrGrade;
  final String majorOptionalSubject;
  final String? comment;
  final String? attachments;
  final bool isSponsored;
  final String? sponsoredBy;
  final String division;

  EmployeeEducationEntity(
      {required this.id,
      required this.employeeId,
      required this.school,
      required this.qualification,
      required this.level,
      required this.yearOfPassing,
      required this.yearOfPassingNp,
      required this.percentageOrGrade,
      required this.majorOptionalSubject,
      required this.comment,
      required this.attachments,
      required this.isSponsored,
      required this.sponsoredBy,
      required this.division});
}
