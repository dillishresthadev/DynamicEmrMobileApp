import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';
import 'package:dynamic_emr/features/holiday/domain/repository/holiday_repository.dart';

class AllHolidayListUsecase {
  final HolidayRepository repository;

  AllHolidayListUsecase({required this.repository});

  Future<List<HolidayEntity>> call() async {
    return await repository.getAllHolidayList();
  }
}
