import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_data_entity.dart';

class LoanAndAdvanceEntity {
  final List<LoanAndAdvanceDataEntity> loanAndAdvanceData;
  final int balanceAmount;

  LoanAndAdvanceEntity({
    required this.loanAndAdvanceData,
    required this.balanceAmount,
  });
}
