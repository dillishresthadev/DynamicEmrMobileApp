class TaxesEntity {
  final String month;
  final String year;
  final double sst;
  final double incomeTax;
  final double totalDeduction;

  TaxesEntity({
    required this.month,
    required this.year,
    required this.sst,
    required this.incomeTax,
    required this.totalDeduction,
  });
}
