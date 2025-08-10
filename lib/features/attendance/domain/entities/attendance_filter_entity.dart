class AttendanceFilterEntity {
  final DateTime fromDate;
  final DateTime toDate;
  final String shiftType;

  AttendanceFilterEntity({
    required this.fromDate,
    required this.toDate,
    required this.shiftType,
  });
}
