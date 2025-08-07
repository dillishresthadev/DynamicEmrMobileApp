
import 'package:dynamic_emr/features/profile/domain/entities/employee_emergency_contact_entity.dart';

class EmployeeEmergencyContactModel extends EmployeeEmergencyContactEntity {
  EmployeeEmergencyContactModel(
      {required super.id,
      required super.employeeId,
      required super.contactPerson,
      required super.phoneNumber,
      required super.relation,
      required super.employeeName,
      required super.employeeCode});

  // Factory method to create an instance from JSON
  factory EmployeeEmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmployeeEmergencyContactModel(
      id: json['id'],
      employeeId: json['employeeId'],
      contactPerson: json['contactPerson'],
      phoneNumber: json['phoneNumber'],
      relation: json['relation'],
      employeeName: json['employeeName'],
      employeeCode: json['employeeCode'],
    );
  }

  // Method to convert the object into a JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'contactPerson': contactPerson,
      'phoneNumber': phoneNumber,
      'relation': relation,
      'employeeName': employeeName,
      'employeeCode': employeeCode,
    };
  }
}
