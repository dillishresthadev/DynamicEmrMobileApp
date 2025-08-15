part of 'payroll_bloc.dart';

enum PayrollStatus { initial, loading, success, error }

final class PayrollState extends Equatable {
  final SalaryEntity? currentMonthSalary;
  final LoanAndAdvanceEntity? loanAndAdvance;
  final List<TaxesEntity> taxes;

  final PayrollStatus currentMonthSalaryStatus;
  final PayrollStatus loanAndAdvanceStatus;
  final PayrollStatus taxesStatus;

  final PayrollStatus status;
  final String message;

  final String currentMonthSalaryMessage;
  final String loanAndAdvanceMessage;
  final String taxesMessage;

  const PayrollState({
    this.currentMonthSalary,
    this.loanAndAdvance,
    this.taxes = const [],
    this.status = PayrollStatus.initial,
    this.currentMonthSalaryStatus = PayrollStatus.initial,
    this.loanAndAdvanceStatus = PayrollStatus.initial,
    this.taxesStatus = PayrollStatus.initial,

    this.currentMonthSalaryMessage = '',
    this.loanAndAdvanceMessage = '',
    this.taxesMessage = '',
    this.message = '',
  });

  PayrollState copyWith({
    SalaryEntity? currentMonthSalary,
    LoanAndAdvanceEntity? loanAndAdvance,
    List<TaxesEntity>? taxes,
    PayrollStatus? status,
    PayrollStatus? currentMonthSalaryStatus,
    PayrollStatus? loanAndAdvanceStatus,
    PayrollStatus? taxesStatus,
    String? currentMonthSalaryMessage,
    String? loanAndAdvanceMessage,
    String? taxesMessage,
    String? message,
  }) {
    return PayrollState(
      currentMonthSalary: currentMonthSalary ?? this.currentMonthSalary,
      loanAndAdvance: loanAndAdvance ?? this.loanAndAdvance,
      taxes: taxes ?? this.taxes,
      status: status ?? this.status,
      currentMonthSalaryStatus:
          currentMonthSalaryStatus ?? this.currentMonthSalaryStatus,
      loanAndAdvanceStatus: loanAndAdvanceStatus ?? this.loanAndAdvanceStatus,
      taxesStatus: taxesStatus ?? this.taxesStatus,
      currentMonthSalaryMessage:
          currentMonthSalaryMessage ?? this.currentMonthSalaryMessage,
      loanAndAdvanceMessage:
          loanAndAdvanceMessage ?? this.loanAndAdvanceMessage,
      taxesMessage: taxesMessage ?? this.taxesMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    currentMonthSalary,
    loanAndAdvance,
    taxes,
    status,
    currentMonthSalaryStatus,
    loanAndAdvanceStatus,
    taxesStatus,
    currentMonthSalaryMessage,
    loanAndAdvanceMessage,
    taxesMessage,
    message,
  ];
}
