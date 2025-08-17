import 'package:dynamic_emr/features/holiday/data/models/holiday_date_model.dart';
import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';

class HolidayModel extends HolidayEntity {
  HolidayModel({
    required super.id,
    required super.title,
    required super.fromDate,
    required super.toDate,
    required super.fromDateNp,
    required super.toDateNp,
    required super.totalHolidays,
    required super.color,
    required super.holidayDates,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
    id: json["id"],
    title: json["title"],
    fromDate: DateTime.parse(json["fromDate"]),
    toDate: DateTime.parse(json["toDate"]),
    fromDateNp: json["fromDateNp"],
    toDateNp: json["toDateNp"],
    totalHolidays: json["totalHolidays"],
    color: json["color"],
    holidayDates: List<HolidayDateModel>.from(
      json["holidayDates"].map((x) => HolidayDateModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "fromDate": fromDate.toIso8601String(),
    "toDate": toDate.toIso8601String(),
    "fromDateNp": fromDateNp,
    "toDateNp": toDateNp,
    "totalHolidays": totalHolidays,
    "color": color,
    "holidayDates": List<dynamic>.from(
      holidayDates.map((x) => (x as HolidayDateModel).toJson()),
    ),
  };
}
