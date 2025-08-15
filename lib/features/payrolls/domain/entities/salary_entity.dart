import 'package:dynamic_emr/features/payrolls/domain/entities/monthly_salary_data_entity.dart';

class SalaryEntity {
  final int month;
  final int year;
  final int nextMonth;
  final int nextYear;
  final int previousMonth;
  final int previousYear;
  final List<MonthlySalaryDataEntity> monthlySalaryData;
  final double grossTotal;
  final double netTotal;

  SalaryEntity({
    required this.month,
    required this.year,
    required this.nextMonth,
    required this.nextYear,
    required this.previousMonth,
    required this.previousYear,
    required this.monthlySalaryData,
    required this.grossTotal,
    required this.netTotal,
  });
}
