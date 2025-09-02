import 'package:dynamic_emr/features/work/domain/entities/business_client_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class BusinessClientUsecase {
  final WorkRepository repository;

  BusinessClientUsecase({required this.repository});

  Future<List<BusinessClientEntity>> call() async {
    return await repository.getBusinessClient();
  }
}
