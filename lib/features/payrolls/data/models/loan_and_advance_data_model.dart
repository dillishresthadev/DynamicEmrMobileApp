import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_data_entity.dart';

class LoanAndAdvanceDataModel extends LoanAndAdvanceDataEntity {
  LoanAndAdvanceDataModel({
    required super.title,
    required super.amount,
    required super.nature,
  });

  factory LoanAndAdvanceDataModel.fromJson(Map<String, dynamic> json) {
    return LoanAndAdvanceDataModel(
      title: json['title'],
      amount: (json['amount'] as num).toInt(),
      nature: json['nature'],
    );
  }
}
