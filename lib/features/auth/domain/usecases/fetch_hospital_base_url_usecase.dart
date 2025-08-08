import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class FetchHospitalBaseUrlUsecase {
  final AuthRepository repository;

  FetchHospitalBaseUrlUsecase({required this.repository});

  Future<String> call(String hospitalCode) {
    return repository.getHospitalBaseUrl(hospitalCode: hospitalCode);
  }
}
