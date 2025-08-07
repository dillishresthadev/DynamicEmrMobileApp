import 'package:dynamic_emr/features/auth/domain/entities/user_financial_year_entity.dart';

class UserFinancialYearModel extends UserFinancialYearEntity {
  const UserFinancialYearModel({
    required super.financialYearId,
    required super.financialYearCode,
    required super.isActive,
    required super.isLocked,
    required super.isClosed,
  });

  factory UserFinancialYearModel.fromJson(Map<String, dynamic> json) {
    return UserFinancialYearModel(
      financialYearId: json['financialYearId'] as int,
      financialYearCode: json['financialYearCode'] as String,
      isActive: json['isActive'] as String,
      isLocked: json['isLocked'] as String,
      isClosed: json['isClosed'] as String,
    );
  }
}
