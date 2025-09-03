class BusinessClientEntity {
  final int? id;
  final String clientName;
  final String address;
  final String? phoneNumber;
  final String? mobileNumber;
  final String? emailAddress;
  final String? clientType;
  final bool? isActive;

  BusinessClientEntity({
    required this.id,
    required this.clientName,
    required this.address,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.emailAddress,
    required this.clientType,
    required this.isActive,
  });
}
