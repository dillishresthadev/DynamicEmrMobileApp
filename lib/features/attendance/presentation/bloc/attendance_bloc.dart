import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/attendance/domain/entities/attendance_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/attendance_summary_usecase.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/current_month_attendance_extended_usecase.dart';
import 'package:dynamic_emr/features/attendance/domain/usecases/current_month_attendance_primary_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final CurrentMonthAttendancePrimaryUsecase
  currentMonthAttendancePrimaryUsecase;
  final CurrentMonthAttendanceExtendedUsecase
  currentMonthAttendanceExtendedUsecase;
  final AttendanceSummaryUsecase attendanceSummaryUsecase;
  AttendanceBloc({
    required this.currentMonthAttendancePrimaryUsecase,
    required this.currentMonthAttendanceExtendedUsecase,
    required this.attendanceSummaryUsecase,
  }) : super(AttendanceInitialState()) {
    on<GetCurrentMonthAttendancePrimaryEvent>(
      _onGetCurrentMonthAttendancePrimary,
    );
    on<GetCurrentMonthAttendanceExtendedEvent>(
      _onGetCurrentMonthAttendanceExtended,
    );
    on<GetAttendanceSummaryEvent>(_onGetAttendanceSummaryEvent);
  }

  Future<void> _onGetCurrentMonthAttendancePrimary(
    GetCurrentMonthAttendancePrimaryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoadingState());
      final currentMonthAttendancePrimary =
          await currentMonthAttendancePrimaryUsecase.call();

      if (state is AttendanceCompleteState) {
        emit(
          (state as AttendanceCompleteState).copyWith(
            primary: currentMonthAttendancePrimary,
          ),
        );
      } else {
        emit(AttendanceCompleteState(primary: currentMonthAttendancePrimary));
      }
    } catch (e) {
      log("Error on bloc [currentMonthAttendancePrimary] :$e");
      emit(AttendanceErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onGetCurrentMonthAttendanceExtended(
    GetCurrentMonthAttendanceExtendedEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoadingState());
      final currentMonthAttendanceExtended =
          await currentMonthAttendanceExtendedUsecase.call();

      if (state is AttendanceCompleteState) {
        emit(
          (state as AttendanceCompleteState).copyWith(
            extended: currentMonthAttendanceExtended,
          ),
        );
      } else {
        emit(AttendanceCompleteState(extended: currentMonthAttendanceExtended));
      }
    } catch (e) {
      log("Error on bloc [currentMonthAttendanceExtended] :$e");
      emit(AttendanceErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onGetAttendanceSummaryEvent(
    GetAttendanceSummaryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
    emit(AttendanceLoadingState());
    final attendanceSummary = await attendanceSummaryUsecase.call(
      fromDate: event.fromDate,
      toDate: event.toDate,
      shiftType: event.shiftType,
    );

    if (state is AttendanceCompleteState) {
      emit((state as AttendanceCompleteState).copyWith(
        attendanceSummary: attendanceSummary,
      ));
    } else {
      emit(AttendanceCompleteState(attendanceSummary: attendanceSummary));
    }
  } catch (e) {
    log("Error on bloc [GetAttendanceSummary] :$e");
    emit(AttendanceSummaryErrorState(errorMessage: e.toString()));
  }
  }
}
