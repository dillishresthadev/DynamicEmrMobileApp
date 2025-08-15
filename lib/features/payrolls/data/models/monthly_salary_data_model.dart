import 'package:dynamic_emr/features/payrolls/domain/entities/monthly_salary_data_entity.dart';

class MonthlySalaryDataModel extends MonthlySalaryDataEntity {
  MonthlySalaryDataModel({
    required super.payHead,
    required super.amount,
    required super.additionOrDeduction,
  });

  factory MonthlySalaryDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalaryDataModel(
      payHead: json['payHead'],
      amount:( json['amount'] as num).toDouble(),
      additionOrDeduction: json['additionOrDeduction'],
    );
  }
}
