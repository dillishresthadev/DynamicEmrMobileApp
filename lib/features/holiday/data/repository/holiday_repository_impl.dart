import 'package:dynamic_emr/features/holiday/data/datasource/holiday_remote_datasource.dart';
import 'package:dynamic_emr/features/holiday/domain/entities/holiday_entity.dart';
import 'package:dynamic_emr/features/holiday/domain/repository/holiday_repository.dart';

class HolidayRepositoryImpl extends HolidayRepository {
  final HolidayRemoteDatasource remoteDatasource;

  HolidayRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<HolidayEntity>> getAllHolidayList() async {
    return await remoteDatasource.getAllHolidayList();
  }

  @override
  Future<List<HolidayEntity>> getPastHolidayList() async {
    return await remoteDatasource.getPastHolidayList();
  }

  @override
  Future<List<HolidayEntity>> getUpcommingHolidayList() async {
    return await remoteDatasource.getUpcommingHolidayList();
  }
}
