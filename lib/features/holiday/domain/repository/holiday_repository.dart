import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';

abstract class HolidayRepository {
  Future<List<HolidayEntity>> getAllHolidayList();
  Future<List<HolidayEntity>> getPastHolidayList();
  Future<List<HolidayEntity>> getUpcommingHolidayList();
}
