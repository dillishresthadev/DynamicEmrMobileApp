class UserFinancialYearEntity {
  final int financialYearId;
  final String financialYearCode;
  final String isActive;
  final String isLocked;
  final String isClosed;

  const UserFinancialYearEntity({
    required this.financialYearId,
    required this.financialYearCode,
    required this.isActive,
    required this.isLocked,
    required this.isClosed,
  });
}
