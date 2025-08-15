import 'package:dynamic_emr/features/payrolls/data/models/monthly_salary_data_model.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';

class SalaryModel extends SalaryEntity {
  SalaryModel({
    required super.month,
    required super.year,
    required super.nextMonth,
    required super.nextYear,
    required super.previousMonth,
    required super.previousYear,
    required super.monthlySalaryData,
    required super.grossTotal,
    required super.netTotal,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      month: json['month'],
      year: json['year'],
      nextMonth: json['nextMonth'],
      nextYear: json['nextYear'],
      previousMonth: json['previousMonth'],
      previousYear: json['previousYear'],
      monthlySalaryData: (json['monthlySalaryData'] as List)
          .map((e) => MonthlySalaryDataModel.fromJson(e))
          .toList(),
      grossTotal: (json['grossTotal'] as num).toDouble(),
      netTotal: (json['netTotal'] as num).toDouble(),
    );
  }
}
