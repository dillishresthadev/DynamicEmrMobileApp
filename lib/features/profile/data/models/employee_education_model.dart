
import 'package:dynamic_emr/features/profile/domain/entities/employee_education_entity.dart';

class EmployeeEducationModel extends EmployeeEducationEntity {
  EmployeeEducationModel(
      {required super.id,
      required super.employeeId,
      required super.school,
      required super.qualification,
      required super.level,
      required super.yearOfPassing,
      required super.yearOfPassingNp,
      required super.percentageOrGrade,
      required super.majorOptionalSubject,
      required super.comment,
      required super.attachments,
      required super.isSponsored,
      required super.sponsoredBy,
      required super.division});

  factory EmployeeEducationModel.fromJson(Map<String, dynamic> json) {
    return EmployeeEducationModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      school: json['school'] ?? '',
      qualification: json['qualification'] ?? '',
      level: json['level'] ?? '',
      yearOfPassing: json['yearOfPassing'] ?? '',
      yearOfPassingNp: json['yearOfPassingNp'] ?? '',
      percentageOrGrade: json['percentageOrGrade'] ?? '',
      majorOptionalSubject: json['majorOptionalSubject'] ?? '',
      comment: json['comment'] ?? '',
      attachments: json['attachments'] ?? '',
      isSponsored: json['isSponsored'] ?? '',
      sponsoredBy: json['sponsoredBy'] ?? '',
      division: json['division'] ?? '',
    );
  }
}
