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
}
