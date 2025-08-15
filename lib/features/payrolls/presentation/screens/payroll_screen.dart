import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:dynamic_emr/features/payrolls/presentation/widgets/loan_advance_card_widget.dart';
import 'package:dynamic_emr/features/payrolls/presentation/widgets/salary_card_widget.dart';
import 'package:dynamic_emr/features/payrolls/presentation/widgets/taxes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  String selectedMonth = 'Baisakh';

  int currentMonth = NepaliDateTime.now().month;
  int currentYear = NepaliDateTime.now().year;

  final List<String> months = [
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

  @override
  void initState() {
    super.initState();
    final nepaliMonthIndex = months.indexOf(selectedMonth) + 1;
    context.read<PayrollBloc>().add(MonthlySalaryEvent(nepaliMonthIndex, 2081));
    context.read<PayrollBloc>().add(CurrentMonthSalaryEvent());
    context.read<PayrollBloc>().add(LoanAndAdvanceEvent());
    context.read<PayrollBloc>().add(TaxesEvent());
  }

  Future<void> _previousMonth() async {
    int newMonth = currentMonth;
    int newYear = currentYear;

    if (newMonth == 1) {
      newMonth = 12;
      newYear--;
    } else {
      newMonth--;
    }

    context.read<PayrollBloc>().add(MonthlySalaryEvent(newMonth, newYear));

    if (mounted) {
      setState(() {
        currentMonth = newMonth;
        currentYear = newYear;
      });
    }
  }

  Future<void> _nextMonth() async {
    int newMonth = currentMonth;
    int newYear = currentYear;

    if (newMonth == 12) {
      newMonth = 1;
      newYear++;
    } else {
      newMonth++;
    }

    context.read<PayrollBloc>().add(MonthlySalaryEvent(newMonth, newYear));

    if (mounted) {
      setState(() {
        currentMonth = newMonth;
        currentYear = newYear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(title: "Payroll Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Salary Section
            SalaryCardWidget(
              currentMonth: currentMonth,
              currentYear: currentYear,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
            ),
            // Taxes Section
            TaxesCard(),

            // Loans & Advances Section
            LoanAdvanceCardWidget(
              currentMonth: currentMonth,
              currentYear: currentYear,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoansAdvancesCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
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

            Container(
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
                  _buildLoanRow('Loan/Advance', 'Rs. 25,000', isPositive: true),
                  const SizedBox(height: 8),
                  _buildLoanRow(
                    '$selectedMonth 2081',
                    'Rs. 5,000',
                    isPositive: false,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _buildLoanRow('Balance', 'Rs. 20,000', isBalance: true),
                ],
              ),
            ),
          ],
        ),
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
            if (!isHeader) ...[
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
