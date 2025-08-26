import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaxesCard extends StatelessWidget {
  final int currentMonth;
  final int currentYear;

  const TaxesCard({
    super.key,
    required this.currentMonth,
    required this.currentYear,
  });

  String formatCurrencyNepali(double amount) {
    String amt = amount.toStringAsFixed(2); // keep 2 decimal places
    String decimalPart = "";
    if (amt.contains(".")) {
      decimalPart = amt.substring(amt.indexOf("."));
      amt = amt.substring(0, amt.indexOf("."));
    }

    // First group: take last 3 digits
    String result = "";
    if (amt.length > 3) {
      String last3 = amt.substring(amt.length - 3);
      String remaining = amt.substring(0, amt.length - 3);

      // Group remaining digits in 2s
      List<String> groups = [];
      while (remaining.length > 2) {
        groups.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }
      if (remaining.isNotEmpty) {
        groups.insert(0, remaining);
      }

      result = "${groups.join(",")},$last3";
    } else {
      result = amt;
    }

    return result + decimalPart;
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      'Baisakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashoj',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra',
    ];
    final monthName = months[currentMonth - 1];

    return BlocBuilder<PayrollBloc, PayrollState>(
      builder: (context, state) {
        switch (state.taxesStatus) {
          case PayrollStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case PayrollStatus.success:
            if (state.taxes.isEmpty) {
              return const Center(child: Text('No tax details available'));
            }

            // filter tax data
            final filtered = state.taxes
                .where(
                  (t) =>
                      t.month.toLowerCase() == monthName.toLowerCase() &&
                      t.year.toString() == currentYear.toString(),
                )
                .toList();

            if (filtered.isEmpty) {
              return SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: filtered.map((tax) {
                  return Card(
                    color: Color(0xFFFEF2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$monthName, $currentYear",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _taxRow("SST", formatCurrencyNepali(tax.sst)),
                          _taxRow(
                            "Income Tax",
                            formatCurrencyNepali(tax.incomeTax),
                          ),
                          const Divider(height: 20),
                          _taxRow(
                            "Total Deduction",
                            formatCurrencyNepali(tax.totalDeduction),
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _taxRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: highlight ? AppColors.primary : Colors.black,
            ),
          ),
          Text(
            "Rs. $value",
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
              color: highlight ? AppColors.primary : Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}
