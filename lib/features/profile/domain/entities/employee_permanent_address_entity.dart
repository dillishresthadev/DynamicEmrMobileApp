class EmployeePermanentAddressEntity {
  final String addressLine1;
  final String? city;
  final String ward;
  final String municipalName;

  EmployeePermanentAddressEntity(
      {required this.addressLine1,
      required this.city,
      required this.ward,
      required this.municipalName});
}
