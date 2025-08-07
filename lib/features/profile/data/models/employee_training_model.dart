import 'package:dynamic_emr/features/profile/domain/entities/employee_training_entity.dart';

class EmployeeTrainingModel extends EmployeeTrainingEntity {
  EmployeeTrainingModel({
    required super.id,
    required super.employeeId,
    required super.title,
    required super.fromDate,
    required super.toDate,
    required super.fromDateNp,
    required super.toDateNp,
    required super.institute,
    required super.country,
    required super.majorSubject,
    required super.isSponsored,
    required super.sponsoredBy,
    required super.employeeName,
    required super.remarks,
    required super.participationType,
    required super.employeeCode,
    required super.attachments,
  });

  factory EmployeeTrainingModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTrainingModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      title: json['title'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      fromDateNp: json['fromDateNp'] ?? '',
      toDateNp: json['toDateNp'] ?? '',
      institute: json['institute'] ?? '',
      country: json['country'] ?? '',
      majorSubject: json['majorSubject'] ?? '',
      isSponsored: json['isSponsored'] ?? '',
      sponsoredBy: json['sponsoredBy'] ?? '',
      employeeName: json['employeeName'] ?? '',
      remarks: json['remarks'] ?? '',
      participationType: json['participationType'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      attachments: json['attachments'] ?? '',
    );
  }
}
