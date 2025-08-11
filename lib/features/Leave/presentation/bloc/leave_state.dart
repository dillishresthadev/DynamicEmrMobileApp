part of 'leave_bloc.dart';

sealed class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object> get props => [];
}

final class LeaveInitialState extends LeaveState {}

final class LeaveLoadingState extends LeaveState {}

final class LeaveApplicationHistoryLoadingState extends LeaveState {}

final class LeaveHistoryLoadingState extends LeaveState {}

// Employee leave application history list taken by employee
final class LeaveApplicationHistoryLoadedState extends LeaveState {
  final List<LeaveApplicationEntity> leaveApplication;

  const LeaveApplicationHistoryLoadedState({required this.leaveApplication});
  @override
  List<Object> get props => [leaveApplication];
}

final class LeaveApplicationHistoryErrorState extends LeaveState {
  final String errorMessage;

  const LeaveApplicationHistoryErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// Employee leave history - allocated,taken leaves data
final class LeaveHistoryLoadedState extends LeaveState {
  final List<LeaveHistoryEntity> leaveHistory;

  const LeaveHistoryLoadedState({required this.leaveHistory});
  @override
  List<Object> get props => [leaveHistory];
}

final class LeaveHistoryErrorState extends LeaveState {
  final String errorMessage;

  const LeaveHistoryErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// Employee Approved Leaves
final class ApprovedLeaveLoadedState extends LeaveState {
  final List<LeaveApplicationEntity> approvedLeave;

  const ApprovedLeaveLoadedState({required this.approvedLeave});
  @override
  List<Object> get props => [approvedLeave];
}

final class ApprovedLeaveErrorState extends LeaveState {
  final String errorMessage;

  const ApprovedLeaveErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// Employee Pending Leaves
final class PendingLeaveLoadedState extends LeaveState {
  final List<LeaveApplicationEntity> pendingLeave;

  const PendingLeaveLoadedState({required this.pendingLeave});
  @override
  List<Object> get props => [pendingLeave];
}

final class PendingLeaveErrorState extends LeaveState {
  final String errorMessage;

  const PendingLeaveErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
