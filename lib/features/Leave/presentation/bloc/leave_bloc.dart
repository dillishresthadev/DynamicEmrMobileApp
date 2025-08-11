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
  }) : super(LeaveInitialState()) {
    on<LeaveHistoryEvent>(_onLeaveHistory);
    on<LeaveApplicationHistoryEvent>(_onLeaveApplicationHistory);
    on<ApprovedLeaveListEvent>(_onApprovedLeaveList);
    on<PendingLeaveListEvent>(_onPendingLeaveList);
  }

  Future<void> _onLeaveHistory(
    LeaveHistoryEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      emit(LeaveHistoryLoadingState());
      final leaveHistory = await leaveHistoryUsecase.call();
      emit(LeaveHistoryLoadedState(leaveHistory: leaveHistory));
    } catch (e) {
      log("Error on Bloc [LeaveHistory] $e");
      emit(LeaveHistoryErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLeaveApplicationHistory(
    LeaveApplicationHistoryEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      emit(LeaveApplicationHistoryLoadingState());
      final leaveApplicationHistory = await leaveApplicationHistoryUsecase
          .call();
      emit(
        LeaveApplicationHistoryLoadedState(
          leaveApplication: leaveApplicationHistory,
        ),
      );
    } catch (e) {
      log("Error on Bloc [leaveApplicationHistory] $e");
      emit(LeaveApplicationHistoryErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onApprovedLeaveList(
    ApprovedLeaveListEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      emit(LeaveLoadingState());
      final approvedLeave = await approvedLeaveListUsecase.call();
      emit(ApprovedLeaveLoadedState(approvedLeave: approvedLeave));
    } catch (e) {
      log("Error on Bloc [ApprovedLeave] $e");
      emit(ApprovedLeaveErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onPendingLeaveList(
    PendingLeaveListEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      emit(LeaveLoadingState());
      final pendingLeave = await pendingLeaveListUsecase.call();
      emit(PendingLeaveLoadedState(pendingLeave: pendingLeave));
    } catch (e) {
      log("Error on Bloc [pendingLeave] $e");
      emit(PendingLeaveErrorState(errorMessage: e.toString()));
    }
  }
}
