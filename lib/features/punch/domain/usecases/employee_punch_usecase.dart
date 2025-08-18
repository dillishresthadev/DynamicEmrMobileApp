import 'package:dynamic_emr/features/punch/domain/repository/punch_repository.dart';

class EmployeePunchUsecase {
  final PunchRepository repository;

  EmployeePunchUsecase({required this.repository});

  Future<bool> call(String longitude, String latitude) async {
    return await repository.postTodayPunch(longitude, latitude);
  }
}
