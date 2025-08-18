import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class GetLeavesByContractidFiscalyearUsecase {
  final LeaveRepository repository;

  GetLeavesByContractidFiscalyearUsecase({required this.repository});

  Future<List<LeaveApplicationEntity>> call(
    int contractId,
    int fiscalYearId,
  ) async {
    return await repository.getLeavesByContractIdAndFiscalYearId(
      contractId,
      fiscalYearId,
    );
  }
}
