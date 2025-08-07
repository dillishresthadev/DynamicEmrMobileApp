class EmployeeDocumentEntity {
  final int? id;
  final int? documentNumberSequence;
  final String documentNumber;
  final int? employeeId;
  final int? documentTypeId;
  final String? attachmentPath;
  final String? issueDate;
  final String? issueDateNp;
  final String? issuePlace;
  final String? expiryDateNp;
  final String? expiryDate;
  final String? notificationType;
  final int? days;
  final String employeeName;
  final String? employeeCode;
  final String? documentType;

  EmployeeDocumentEntity(
      {required this.id,
      required this.documentNumberSequence,
      required this.documentNumber,
      required this.employeeId,
      required this.documentTypeId,
      required this.attachmentPath,
      required this.issueDate,
      required this.issueDateNp,
      required this.issuePlace,
      required this.expiryDateNp,
      required this.expiryDate,
      required this.notificationType,
      required this.days,
      required this.employeeName,
      required this.employeeCode,
      required this.documentType});
}
