import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';

class BusinessClientModel extends BusinessClientEntity {
  BusinessClientModel({
    required super.id,
    required super.clientName,
    required super.address,
    required super.phoneNumber,
    required super.mobileNumber,
    required super.emailAddress,
    required super.clientType,
    required super.isActive,
  });

  factory BusinessClientModel.fromJson(Map<String, dynamic> json) {
    return BusinessClientModel(
      id: json['id'],
      clientName: json['clientName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      mobileNumber: json['mobileNumber'],
      emailAddress: json['emailAddress'],
      clientType: json['clientType'],
      isActive: json['isActive'],
    );
  }
}
