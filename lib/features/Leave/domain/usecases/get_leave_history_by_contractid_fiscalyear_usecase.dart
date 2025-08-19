import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/repository/leave_repository.dart';

class GetLeaveHistoryByContractidFiscalyearUsecase {
  final LeaveRepository repository;

  GetLeaveHistoryByContractidFiscalyearUsecase({required this.repository});
  Future<List<LeaveHistoryEntity>> call(
    int contractId,
    int fiscalYearId,
  ) async {
    return await repository.getLeaveHistoryByContractIdAndFiscalYearId(
      contractId,
      fiscalYearId,
    );
  }
}
