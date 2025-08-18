import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart'
    show LeaveTypeEntity;
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class GetFiscalyearByContractidUsecase {
  final LeaveRepository repository;

  GetFiscalyearByContractidUsecase({required this.repository});

  Future<List<LeaveTypeEntity>> call(int contractId) async {
    return await repository.getFiscalYearByContractId(contractId);
  }
}
