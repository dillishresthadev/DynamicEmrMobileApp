import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/payroll_bloc.dart';

class LoanAdvanceCardWidget extends StatelessWidget {
  final int currentMonth;
  final int currentYear;

  const LoanAdvanceCardWidget({
    super.key,
    required this.currentMonth,
    required this.currentYear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loans & Advances',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          BlocBuilder<PayrollBloc, PayrollState>(
            builder: (context, state) {
              if (state.loanAndAdvanceStatus == PayrollStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.loanAndAdvanceStatus == PayrollStatus.success) {
                final loanDataList = state.loanAndAdvance?.loanAndAdvanceData;
                final totalAmount = state.loanAndAdvance?.balanceAmount;
                if (loanDataList == null || loanDataList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No loans or advances data available.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    children: [
                      _buildLoanRow('Particular', 'Amount', isHeader: true),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // Render each loan/advance entry
                      ...loanDataList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildLoanRow(
                            item.title,
                            'Rs. ${item.amount.toStringAsFixed(2)}',
                            isPositive: item.amount > 0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // Total
                      _buildLoanRow(
                        'Total',
                        'Rs. ${totalAmount?.toStringAsFixed(2)}',
                        isBalance: true,
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoanRow(
    String particular,
    String amount, {
    bool isHeader = false,
    bool isPositive = false,
    bool isBalance = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          particular,
          style: TextStyle(
            fontSize: isHeader ? 14 : 15,
            fontWeight: isHeader || isBalance
                ? FontWeight.w600
                : FontWeight.w400,
            color: isHeader ? const Color(0xFF7F8C8D) : const Color(0xFF2C3E50),
          ),
        ),
        Row(
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: isHeader ? 14 : 15,
                fontWeight: isHeader || isBalance
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: isHeader
                    ? const Color(0xFF7F8C8D)
                    : isBalance
                    ? const Color(0xFF3498DB)
                    : isPositive
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFE74C3C),
              ),
            ),
            if (!isHeader && !isBalance) ...[
              const SizedBox(width: 8),
              Text(
                isPositive ? '(+)' : '(-)',
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFE74C3C),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
