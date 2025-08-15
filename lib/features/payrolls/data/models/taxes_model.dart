import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';

class TaxesModel extends TaxesEntity {
  TaxesModel({
    required super.month,
    required super.year,
    required super.sst,
    required super.incomeTax,
    required super.totalDeduction,
  });

  factory TaxesModel.fromJson(Map<String, dynamic> json) {
    return TaxesModel(
      month: json['month'],
      year: json['year'],
      sst: (json['sst'] as num).toDouble(),
      incomeTax: (json['incomeTax'] as num).toDouble(),
      totalDeduction: (json['totalDeduction'] as num).toDouble(),
    );
  }
}
