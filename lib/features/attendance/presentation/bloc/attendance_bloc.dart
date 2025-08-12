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
  }) : super(const AttendanceState()) {
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
    emit(state.copyWith(status: AttendanceStatus.loading));
    try {
      final currentMonthAttendancePrimary =
          await currentMonthAttendancePrimaryUsecase.call();
      emit(
        state.copyWith(
          primary: currentMonthAttendancePrimary,
          status: AttendanceStatus.loadPrimarySuccess,
        ),
      );
    } catch (e) {
      log("Error on bloc [currentMonthAttendancePrimary] : $e");
      emit(
        state.copyWith(
          status: AttendanceStatus.loadPrimaryError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetCurrentMonthAttendanceExtended(
    GetCurrentMonthAttendanceExtendedEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.loading));
    try {
      final currentMonthAttendanceExtended =
          await currentMonthAttendanceExtendedUsecase.call();
      emit(
        state.copyWith(
          extended: currentMonthAttendanceExtended,
          status: AttendanceStatus.loadExtendedSuccess,
        ),
      );
    } catch (e) {
      log("Error on bloc [currentMonthAttendanceExtended] : $e");
      emit(
        state.copyWith(
          status: AttendanceStatus.loadExtendedError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetAttendanceSummaryEvent(
    GetAttendanceSummaryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.loading));
    try {
      final attendanceSummary = await attendanceSummaryUsecase.call(
        fromDate: event.fromDate,
        toDate: event.toDate,
        shiftType: event.shiftType,
      );
      emit(
        state.copyWith(
          summary: attendanceSummary,
          status: AttendanceStatus.loadSummarySuccess,
        ),
      );
    } catch (e) {
      log("Error on bloc [GetAttendanceSummary] : $e");
      emit(
        state.copyWith(
          status: AttendanceStatus.loadSummaryError,
          message: e.toString(),
        ),
      );
    }
  }
}
