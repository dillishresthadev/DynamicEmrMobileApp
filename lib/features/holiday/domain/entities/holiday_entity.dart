import 'package:dynamic_emr/features/holiday/domain/entities/holiday_date_entity.dart';

class HolidayEntity {
  final int id;
  final String? title;
  final DateTime fromDate;
  final DateTime toDate;
  final String fromDateNp;
  final String toDateNp;
  final int totalHolidays;
  final String? color;
  final List<HolidayDateEntity> holidayDates;

  HolidayEntity({
    required this.id,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.fromDateNp,
    required this.toDateNp,
    required this.totalHolidays,
    required this.color,
    required this.holidayDates,
  });
}
