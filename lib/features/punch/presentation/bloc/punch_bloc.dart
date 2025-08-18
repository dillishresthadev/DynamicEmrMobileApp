import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/punch/domain/entities/employee_punch_entity.dart';
import 'package:dynamic_emr/features/punch/domain/usecases/employee_punch_usecase.dart';
import 'package:dynamic_emr/features/punch/domain/usecases/get_employee_punch_list_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'punch_event.dart';
part 'punch_state.dart';

class PunchBloc extends Bloc<PunchEvent, PunchState> {
  final EmployeePunchUsecase employeePunchUsecase;
  final GetEmployeePunchListUsecase employeePunchListUsecase;
  PunchBloc({
    required this.employeePunchListUsecase,
    required this.employeePunchUsecase,
  }) : super(PunchState()) {
    on<GetTodayPunchListEvent>(_onGetTodayPunchList);
    on<TodayPunchEvent>(_onTodayPunch);
  }

  Future<void> _onGetTodayPunchList(
    GetTodayPunchListEvent event,
    Emitter<PunchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PunchStatus.loading));

      final punchList = await employeePunchListUsecase.call();
      emit(state.copyWith(status: PunchStatus.success, punchList: punchList));
    } catch (e) {
      log("Error on Bloc today punch list $e");
      emit(state.copyWith(status: PunchStatus.error, message: e.toString()));
    }
  }

  Future<void> _onTodayPunch(
    TodayPunchEvent event,
    Emitter<PunchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PunchStatus.loading));
      await employeePunchUsecase.call(event.long, event.lat);
      emit(state.copyWith(status: PunchStatus.success));
    } catch (e) {
      log("Error on Bloc today punch $e");
      emit(state.copyWith(status: PunchStatus.error, message: e.toString()));
    }
  }
}
