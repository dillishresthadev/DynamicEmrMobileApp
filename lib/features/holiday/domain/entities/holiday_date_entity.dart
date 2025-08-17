class HolidayDateEntity {
  final int id;
  final int holidayId;
  final DateTime holidayDate;
  final String description;
  final bool isWeekOff;

  HolidayDateEntity({
    required this.id,
    required this.holidayId,
    required this.holidayDate,
    required this.description,
    required this.isWeekOff,
  });
}
