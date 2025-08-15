import 'package:dynamic_emr/features/payrolls/data/models/loan_and_advance_data_model.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_entity.dart';

class LoanAndAdvanceModel extends LoanAndAdvanceEntity {
  LoanAndAdvanceModel({
    required super.loanAndAdvanceData,
    required super.balanceAmount,
  });

  factory LoanAndAdvanceModel.fromJson(Map<String, dynamic> json) {
    return LoanAndAdvanceModel(
      loanAndAdvanceData: (json['loanAndAdvanceData'] as List)
          .map((e) => LoanAndAdvanceDataModel.fromJson(e))
          .toList(),
      balanceAmount: (json['balanceAmount'] as num).toInt(),
    );
  }
}
