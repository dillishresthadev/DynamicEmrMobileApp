import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';
import 'package:dynamic_emr/features/holiday/domain/repository/holiday_repository.dart';

class PastHolidayListUsecase {
  final HolidayRepository repository;

  PastHolidayListUsecase({required this.repository});

  Future<List<HolidayEntity>> call() async {
    return await repository.getPastHolidayList();
  }
}
