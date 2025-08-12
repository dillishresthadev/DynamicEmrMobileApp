part of 'leave_bloc.dart';

sealed class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object> get props => [];
}

final class LeaveHistoryEvent extends LeaveEvent {}

final class LeaveApplicationHistoryEvent extends LeaveEvent {}

final class ApprovedLeaveListEvent extends LeaveEvent {}

final class PendingLeaveListEvent extends LeaveEvent {}

final class ApplyLeaveEvent extends LeaveEvent {
  final LeaveApplicationRequestEntity leaveRequest;

  const ApplyLeaveEvent({required this.leaveRequest});
  @override
  List<Object> get props => [leaveRequest];
}
