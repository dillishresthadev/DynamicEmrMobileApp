
import 'package:dynamic_emr/features/profile/domain/entities/employee_document_entity.dart';

class EmployeeDocumentModel extends EmployeeDocumentEntity {
  EmployeeDocumentModel(
      {required super.id,
      required super.documentNumberSequence,
      required super.documentNumber,
      required super.employeeId,
      required super.documentTypeId,
      required super.attachmentPath,
      required super.issueDate,
      required super.issueDateNp,
      required super.issuePlace,
      required super.expiryDateNp,
      required super.expiryDate,
      required super.notificationType,
      required super.days,
      required super.employeeName,
      required super.employeeCode,
      required super.documentType});
      
  // Convert JSON to Model
  factory EmployeeDocumentModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDocumentModel(
      id: json['id'] ?? 0,
      documentNumberSequence: json['documentNumberSequence'] ?? 0,
      documentNumber: json['documentNumber'] ?? '',
      employeeId: json['employeeId'] ?? 0,
      documentTypeId: json['documentTypeId'] ?? 0,
      attachmentPath: json['attachmentPath'] ?? '',
      issueDate: json['issueDate'] ?? '',
      issueDateNp: json['issueDateNp'] ?? '',
      issuePlace: json['issuePlace'] ?? '',
      expiryDateNp: json['expiryDateNp'],
      expiryDate: json['expiryDate'],
      notificationType: json['notificationType'],
      days: json['days'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      documentType: json['documentType'] ?? '',
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentNumberSequence': documentNumberSequence,
      'documentNumber': documentNumber,
      'employeeId': employeeId,
      'documentTypeId': documentTypeId,
      'attachmentPath': attachmentPath,
      'issueDate': issueDate,
      'issueDateNp': issueDateNp,
      'issuePlace': issuePlace,
      'expiryDateNp': expiryDateNp,
      'expiryDate': expiryDate,
      'notificationType': notificationType,
      'days': days,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
      'documentType': documentType,
    };
  }
}
