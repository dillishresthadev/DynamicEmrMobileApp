import 'package:dynamic_emr/features/profile/domain/entities/employee_nominee_entity.dart';

class EmployeeNomineeModel extends EmployeeNomineeEntity {
  EmployeeNomineeModel({required super.name, required super.relation});

  factory EmployeeNomineeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeNomineeModel(
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
    );
  }
}
