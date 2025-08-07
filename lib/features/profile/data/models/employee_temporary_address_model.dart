import 'package:dynamic_emr/features/profile/domain/entities/employee_temporary_address_entity.dart';

class EmployeeTemporaryAddressModel extends EmployeeTemporaryAddressEntity {
  EmployeeTemporaryAddressModel({
    required super.addressLine1,
    required super.city,
    required super.ward,
    required super.municipalName,
  });

  factory EmployeeTemporaryAddressModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTemporaryAddressModel(
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      ward: json['ward'] ?? '',
      municipalName: json['municipalName'] ?? '',
    );
  }
}
