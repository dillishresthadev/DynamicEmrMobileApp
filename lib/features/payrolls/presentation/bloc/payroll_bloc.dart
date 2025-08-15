import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/payrolls/domain/entities/loan_and_advance_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/salary_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/current_month_salary_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/loan_and_advance_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/monthly_salary_usecase.dart';
import 'package:dynamic_emr/features/payrolls/domain/usecases/taxes_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payroll_event.dart';
part 'payroll_state.dart';

class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final CurrentMonthSalaryUsecase currentMonthSalaryUsecase;
  final MonthlySalaryUsecase monthlySalaryUsecase;
  final LoanAndAdvanceUsecase loanAndAdvanceUsecase;
  final TaxesUsecase taxesUsecase;

  PayrollBloc({
    required this.currentMonthSalaryUsecase,
    required this.monthlySalaryUsecase,
    required this.loanAndAdvanceUsecase,
    required this.taxesUsecase,
  }) : super(PayrollState()) {
    on<CurrentMonthSalaryEvent>(_onCurrentMonthSalary);
    on<MonthlySalaryEvent>(_onMonthlySalary);
    on<LoanAndAdvanceEvent>(_onLoanAndAdvance);
    on<TaxesEvent>(_onGetTaxes);
  }

  Future<void> _onCurrentMonthSalary(
    CurrentMonthSalaryEvent event,
    Emitter<PayrollState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PayrollStatus.loading));
      final currentMonthSalary = await currentMonthSalaryUsecase.call();
      emit(
        state.copyWith(
          currentMonthSalaryStatus: PayrollStatus.success,
          currentMonthSalary: currentMonthSalary,
        ),
      );
    } catch (e) {
      log("Error on Bloc currentMonthSalary : $e");
      emit(
        state.copyWith(
          currentMonthSalaryStatus: PayrollStatus.error,
          currentMonthSalaryMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onMonthlySalary(
    MonthlySalaryEvent event,
    Emitter<PayrollState> emit,
  ) async {
    try {
      emit(state.copyWith(currentMonthSalaryStatus: PayrollStatus.loading));

      final monthlySalary = await monthlySalaryUsecase.call(
        event.month,
        event.year,
      );

      emit(
        state.copyWith(
          currentMonthSalaryStatus: PayrollStatus.success,
          currentMonthSalary: monthlySalary,
        ),
      );
    } catch (e) {
      log("Error on Bloc monthly salary: $e");
      emit(
        state.copyWith(
          currentMonthSalaryStatus: PayrollStatus.error,
          currentMonthSalaryMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onLoanAndAdvance(
    LoanAndAdvanceEvent event,
    Emitter<PayrollState> emit,
  ) async {
    try {
      emit(state.copyWith(loanAndAdvanceStatus: PayrollStatus.loading));
      
      final loanAndAdvance = await loanAndAdvanceUsecase.call();
      emit(
        state.copyWith(
          loanAndAdvanceStatus: PayrollStatus.success,
          loanAndAdvance: loanAndAdvance,
        ),
      );
    } catch (e) {
      log("Error on Bloc loand and advance : $e");
      emit(
        state.copyWith(
          loanAndAdvanceStatus: PayrollStatus.error,
          loanAndAdvanceMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetTaxes(TaxesEvent event, Emitter<PayrollState> emit) async {
    try {
      emit(state.copyWith(status: PayrollStatus.loading));
      final taxes = await taxesUsecase.call();
      emit(state.copyWith(taxesStatus: PayrollStatus.success, taxes: taxes));
    } catch (e) {
      log("Error on Bloc loand and advance : $e");
      emit(
        state.copyWith(
          taxesStatus: PayrollStatus.error,
          taxesMessage: e.toString(),
        ),
      );
    }
  }
}
