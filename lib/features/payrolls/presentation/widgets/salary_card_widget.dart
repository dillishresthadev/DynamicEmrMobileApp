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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Salary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),

            _buildMonthSelector(),
            const SizedBox(height: 20),

            BlocBuilder<PayrollBloc, PayrollState>(
              builder: (context, state) {
                if (state.currentMonthSalaryStatus == PayrollStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.currentMonthSalaryStatus ==
                    PayrollStatus.success) {
                  final salary = state.currentMonthSalary;
                  if (salary == null || salary.monthlySalaryData.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'No salary data available for this month.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final additions = salary.monthlySalaryData
                      .where((item) => item.additionOrDeduction == "Addition")
                      .toList();
                  final deductions = salary.monthlySalaryData
                      .where((item) => item.additionOrDeduction == "Deduction")
                      .toList();

                  return Column(
                    children: [
                      // Additions
                      ...additions.map(
                        (item) => _buildSalaryItem(
                          item.payHead,
                          item.amount.toStringAsFixed(2),
                          isAddition: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 8),

                      // Deductions
                      ...deductions.map(
                        (item) => _buildSalaryItem(
                          item.payHead,
                          item.amount.toStringAsFixed(2),
                          isAddition: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Totals
                      _buildTotals(
                        gross: salary.grossTotal.toStringAsFixed(2),
                        net: salary.netTotal.toStringAsFixed(2),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.chevron_left, color: Color(0xFF3498DB)),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              "${NepaliDateFormat('MMMM').format(NepaliDateTime(currentYear, currentMonth))} $currentYear",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right, color: Color(0xFF3498DB)),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryItem(
    String title,
    String amount, {
    required bool isAddition,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontSize: 15, color: Color(0xFF2C3E50)),
          ),
          Row(
            children: [
              Text(
                'Rs. $amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isAddition
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFE74C3C),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isAddition ? Icons.add : Icons.remove,
                size: 16,
                color: isAddition
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFE74C3C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotals({required String gross, required String net}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildTotalRow('Gross Total', gross, isGross: true),
          const SizedBox(height: 8),
          _buildTotalRow('Net Total', net, isNet: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value, {
    bool isGross = false,
    bool isNet = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isNet ? const Color(0xFF3498DB) : const Color(0xFF2C3E50),
          ),
        ),
        Text(
          'Rs. $value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isNet ? const Color(0xFF3498DB) : const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
