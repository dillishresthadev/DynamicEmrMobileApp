import 'package:dynamic_emr/features/holiday/domain/entities/holiday_date_entity.dart';

class HolidayDateModel extends HolidayDateEntity {
  HolidayDateModel({
    required super.id,
    required super.holidayId,
    required super.holidayDate,
    required super.description,
    required super.isWeekOff,
  });

    factory HolidayDateModel.fromJson(Map<String, dynamic> json) => HolidayDateModel(
        id: json["id"],
        holidayId: json["holidayId"],
        holidayDate: DateTime.parse(json["holidayDate"]),
        description: json["description"],
        isWeekOff: json["isWeekOff"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holidayId": holidayId,
        "holidayDate": holidayDate.toIso8601String(),
        "description": description,
        "isWeekOff": isWeekOff,
      };
}
