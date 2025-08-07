import 'package:dynamic_emr/features/profile/domain/entities/employee_permanent_address_entity.dart';

class EmployeePermanentAddressModel extends EmployeePermanentAddressEntity {
  EmployeePermanentAddressModel({
    required super.addressLine1,
    required super.city,
    required super.ward,
    required super.municipalName,
  });

  factory EmployeePermanentAddressModel.fromJson(Map<String, dynamic> json) {
    return EmployeePermanentAddressModel(
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      ward: json['ward'] ?? '',
      municipalName: json['municipalName'] ?? '',
    );
  }
}
