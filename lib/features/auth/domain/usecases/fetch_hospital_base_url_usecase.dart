import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';

class FetchHospitalBaseUrlUsecase {
  final UserRepository repository;

  FetchHospitalBaseUrlUsecase({required this.repository});

  Future<String> call(String hospitalCode) {
    return repository.getHospitalBaseUrl(hospitalCode: hospitalCode);
  }
}
