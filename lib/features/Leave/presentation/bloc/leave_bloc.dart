import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/approved_leave_list_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_application_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/pending_leave_list_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveHistoryUsecase leaveHistoryUsecase;
  final LeaveApplicationHistoryUsecase leaveApplicationHistoryUsecase;
  final ApprovedLeaveListUsecase approvedLeaveListUsecase;
  final PendingLeaveListUsecase pendingLeaveListUsecase;

  LeaveBloc({
    required this.leaveHistoryUsecase,
    required this.leaveApplicationHistoryUsecase,
    required this.approvedLeaveListUsecase,
    required this.pendingLeaveListUsecase,
  }) : super(const LeaveState()) {
    on<LeaveHistoryEvent>(_onLeaveHistory);
    on<LeaveApplicationHistoryEvent>(_onLeaveApplicationHistory);
    on<ApprovedLeaveListEvent>(_onApprovedLeaveList);
    on<PendingLeaveListEvent>(_onPendingLeaveList);
  }

  Future<void> _onLeaveHistory(
    LeaveHistoryEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading));
    try {
      final leaveHistory = await leaveHistoryUsecase.call();
      emit(
        state.copyWith(
          leaveHistory: leaveHistory,
          status: LeaveStatus.leaveHistoryLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [LeaveHistory] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.leaveHistoryLoadError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaveApplicationHistory(
    LeaveApplicationHistoryEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading));
    try {
      final leaveApplicationHistory = await leaveApplicationHistoryUsecase
          .call();
      emit(
        state.copyWith(
          leaveApplicationHistory: leaveApplicationHistory,
          status: LeaveStatus.leaveApplicationHistoryLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [LeaveApplicationHistory] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.leaveApplicationHistoryLoadError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onApprovedLeaveList(
    ApprovedLeaveListEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading));
    try {
      final approvedLeave = await approvedLeaveListUsecase.call();
      emit(
        state.copyWith(
          approvedLeave: approvedLeave,
          status: LeaveStatus.approvedLeaveLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [ApprovedLeave] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.approvedLeaveLoadError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPendingLeaveList(
    PendingLeaveListEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading));
    try {
      final pendingLeave = await pendingLeaveListUsecase.call();
      emit(
        state.copyWith(
          pendingLeave: pendingLeave,
          status: LeaveStatus.pendingLeaveLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [PendingLeave] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.pendingLeaveLoadError,
          message: e.toString(),
        ),
      );
    }
  }
}
