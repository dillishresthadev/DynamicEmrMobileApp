import 'package:dynamic_emr/features/auth/domain/entities/hospital_branch_entity.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';

class FetchHospitalBranchUsecase {
  final AuthRepository repository;

  FetchHospitalBranchUsecase({required this.repository});

  Future<List<HospitalBranchEntity>> call() async {
    return await repository.getUserBranches();
  }
}
