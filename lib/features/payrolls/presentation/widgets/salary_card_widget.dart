import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../bloc/payroll_bloc.dart';

class SalaryCardWidget extends StatelessWidget {
  final int currentMonth;
  final int currentYear;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const SalaryCardWidget({
    super.key,
    required this.currentMonth,
    required this.currentYear,
    required this.onPreviousMonth,
    required this.onNextMonth,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthSelector(context),
        const SizedBox(height: 12),

        BlocBuilder<PayrollBloc, PayrollState>(
          builder: (context, state) {
            if (state.currentMonthSalaryStatus == PayrollStatus.loading) {
              return _buildLoadingState();
            } else if (state.currentMonthSalaryStatus ==
                PayrollStatus.success) {
              final salary = state.currentMonthSalary;
              if (salary == null || salary.monthlySalaryData.isEmpty) {
                return _buildEmptyState(context);
              }

              final additions = salary.monthlySalaryData
                  .where((item) => item.additionOrDeduction == "Addition")
                  .toList();
              final deductions = salary.monthlySalaryData
                  .where((item) => item.additionOrDeduction == "Deduction")
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (additions.isNotEmpty) ...[
                    _buildSalarySection(context, additions, true),
                    const SizedBox(height: 8),
                  ],

                  if (deductions.isNotEmpty) ...[
                    _buildSalarySection(context, deductions, false),
                    const SizedBox(height: 8),
                  ],

                  _buildTotalsSection(
                    context,
                    gross: formatCurrencyNepali(salary.grossTotal),
                    net: formatCurrencyNepali(salary.netTotal),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onPreviousMonth,
              icon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.primary,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            Expanded(
              child: Text(
                "${NepaliDateFormat('MMMM').format(NepaliDateTime(currentYear, currentMonth))} $currentYear",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: onNextMonth,
              icon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalarySection(
    BuildContext context,
    List items,
    bool isAddition,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isAddition ? Color(0xFFECFDF5) : Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildSalaryItem(
            context,
            item.payHead,
            formatCurrencyNepali(item.amount),
            isAddition: isAddition,
          );
        },
      ),
    );
  }

  Widget _buildSalaryItem(
    BuildContext context,
    String title,
    String amount, {
    required bool isAddition,
  }) {
    final color = isAddition
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            'Rs. $amount',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(
    BuildContext context, {
    required String gross,
    required String net,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildTotalRow(context, 'Gross Total', gross, false),
          const SizedBox(height: 6),
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 6),
          _buildTotalRow(context, 'Net Total', net, true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    BuildContext context,
    String label,
    String value,
    bool isNet,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isNet
                ? AppColors.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          'Rs. $value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isNet
                ? AppColors.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No salary data available for this month',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
