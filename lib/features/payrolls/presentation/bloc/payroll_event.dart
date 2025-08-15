part of 'payroll_bloc.dart';

sealed class PayrollEvent extends Equatable {
  const PayrollEvent();

  @override
  List<Object> get props => [];
}

final class CurrentMonthSalaryEvent extends PayrollEvent {}

final class LoanAndAdvanceEvent extends PayrollEvent {}

final class TaxesEvent extends PayrollEvent {}

final class MonthlySalaryEvent extends PayrollEvent {
  final int month;
  final int year;

  const MonthlySalaryEvent(this.month, this.year);

  @override
  List<Object> get props => [month, year];
}

