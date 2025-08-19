import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/apply_leave_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/approved_leave_list_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/extended_leave_type_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_application_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_history_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/leave_type_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/pending_leave_list_usecase.dart';
import 'package:dynamic_emr/features/Leave/domain/usecases/substitution_leave_employee_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveHistoryUsecase leaveHistoryUsecase;
  final LeaveApplicationHistoryUsecase leaveApplicationHistoryUsecase;
  final ApprovedLeaveListUsecase approvedLeaveListUsecase;
  final PendingLeaveListUsecase pendingLeaveListUsecase;
  final ApplyLeaveUsecase applyLeaveUsecase;
  final LeaveTypeUsecase leaveTypeUsecase;
  final ExtendedLeaveTypeUsecase extendedLeaveTypeUsecase;
  final SubstitutionLeaveEmployeeUsecase substitutionLeaveEmployeeUsecase;

  LeaveBloc({
    required this.leaveHistoryUsecase,
    required this.leaveApplicationHistoryUsecase,
    required this.approvedLeaveListUsecase,
    required this.pendingLeaveListUsecase,
    required this.applyLeaveUsecase,
    required this.leaveTypeUsecase,
    required this.extendedLeaveTypeUsecase,
    required this.substitutionLeaveEmployeeUsecase,
  }) : super(const LeaveState()) {
    on<LeaveHistoryEvent>(_onLeaveHistory);
    on<LeaveApplicationHistoryEvent>(_onLeaveApplicationHistory);
    on<ApprovedLeaveListEvent>(_onApprovedLeaveList);
    on<PendingLeaveListEvent>(_onPendingLeaveList);
    on<ApplyLeaveEvent>(_onApplyLeave);
    on<LeaveTypeEvent>(_onLeaveType);
    on<LeaveTypeExtendedEvent>(_onLeaveTypeExtended);
    on<SubstitutionEmployeeEvent>(_onSubstitutionEmployee);
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
    emit(state.copyWith(approvedLeaveStatus: LeaveStatus.loading));
    try {
      final approvedLeave = await approvedLeaveListUsecase.call();
      emit(
        state.copyWith(
          approvedLeave: approvedLeave,
          approvedLeaveStatus: LeaveStatus.approvedLeaveLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [ApprovedLeave] $e");
      emit(
        state.copyWith(
          approvedLeaveStatus: LeaveStatus.approvedLeaveLoadError,
          approvedLeaveMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPendingLeaveList(
    PendingLeaveListEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(pendingLeaveStatus: LeaveStatus.loading));
    try {
      final pendingLeave = await pendingLeaveListUsecase.call();
      emit(
        state.copyWith(
          pendingLeave: pendingLeave,
          pendingLeaveStatus: LeaveStatus.pendingLeaveLoadSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [PendingLeave] $e");
      emit(
        state.copyWith(
          pendingLeaveStatus: LeaveStatus.pendingLeaveLoadError,
          pendingLeaveMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onApplyLeave(
    ApplyLeaveEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LeaveStatus.loading));
      final isLeaveApply = await applyLeaveUsecase.call(
        LeaveApplicationRequestEntity(
          leaveTypeId: event.leaveRequest.leaveTypeId,

          fromDate: event.leaveRequest.fromDate,
          fromDateNp: event.leaveRequest.fromDateNp,
          toDate: event.leaveRequest.toDate,
          toDateNp: event.leaveRequest.toDateNp,

          halfDayStatus: event.leaveRequest.halfDayStatus,
          totalLeaveDays: event.leaveRequest.totalLeaveDays,
          reason: event.leaveRequest.reason,

          extendedFromDate: event.leaveRequest.extendedFromDate,
          extendedToDate: event.leaveRequest.extendedToDate,
          extendedFromDateNp: event.leaveRequest.extendedFromDateNp,

          extendedToDateNp: event.leaveRequest.extendedToDateNp,
          extendedLeaveTypeId: event.leaveRequest.extendedLeaveTypeId,
          substituteEmployeeId: event.leaveRequest.substituteEmployeeId,
          isHalfDay: event.leaveRequest.isHalfDay,
        ),
      );
      emit(
        state.copyWith(
          applyLeave: isLeaveApply,
          status: LeaveStatus.applyLeaveSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [ApplyLeave] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.applyLeaveError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaveType(
    LeaveTypeEvent event,
    Emitter<LeaveState> emit,
  ) async {
    emit(state.copyWith(status: LeaveStatus.loading));
    try {
      final leaveType = await leaveTypeUsecase.call();
      emit(
        state.copyWith(
          leaveType: leaveType,
          status: LeaveStatus.leaveTypeSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [Leave Type Primary] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.leaveTypeError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaveTypeExtended(
    LeaveTypeExtendedEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      final leaveTypeExtended = await extendedLeaveTypeUsecase.call();
      emit(
        state.copyWith(
          extendedLeaveType: leaveTypeExtended,
          status: LeaveStatus.extendedLeaveTypeSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [Extended leave type] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.extendedLeaveTypeError,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSubstitutionEmployee(
    SubstitutionEmployeeEvent event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      final substitutionEmployee = await substitutionLeaveEmployeeUsecase
          .call();
      emit(
        state.copyWith(
          substitutionEmployee: substitutionEmployee,
          status: LeaveStatus.substitutionEmployeeSuccess,
        ),
      );
    } catch (e) {
      log("Error on Bloc [Substitution employee] $e");
      emit(
        state.copyWith(
          status: LeaveStatus.substitutionEmployeeError,
          message: e.toString(),
        ),
      );
    }
  }
}
