class EmployeeWorkExperienceEntity {
  final int id;
  final int employeeId;
  final String company;
  final String designation;
  final String salary;
  final String address;
  final String department;
  final String contact;
  final DateTime joiningDate;
  final DateTime leavingDate;
  final String joiningDateNp;
  final String leavingDateNp;
  final String totalExperience;
  final String referencePerson;
  final String referenceContact;
  final String referencePersonEmail;
  final String reasonToLeave;
  final String? employeeName;
  final String? level;
  final int hrmLevelId;
  final String jobSummary;
  final String? employeeCode;
  final String? attachments;

  EmployeeWorkExperienceEntity(
      {required this.id,
      required this.employeeId,
      required this.company,
      required this.designation,
      required this.salary,
      required this.address,
      required this.department,
      required this.contact,
      required this.joiningDate,
      required this.leavingDate,
      required this.joiningDateNp,
      required this.leavingDateNp,
      required this.totalExperience,
      required this.referencePerson,
      required this.referenceContact,
      required this.referencePersonEmail,
      required this.reasonToLeave,
      required this.employeeName,
      required this.level,
      required this.hrmLevelId,
      required this.jobSummary,
      required this.employeeCode,
      required this.attachments});
}
