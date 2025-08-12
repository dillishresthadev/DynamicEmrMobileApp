part of 'leave_bloc.dart';

enum LeaveStatus {
  initial,
  loading,
  leaveHistoryLoadSuccess,
  leaveHistoryLoadError,
  leaveApplicationHistoryLoadSuccess,
  leaveApplicationHistoryLoadError,
  approvedLeaveLoadSuccess,
  approvedLeaveLoadError,
  pendingLeaveLoadSuccess,
  pendingLeaveLoadError,
}

final class LeaveState extends Equatable {
  final List<LeaveHistoryEntity> leaveHistory;
  final List<LeaveApplicationEntity> leaveApplicationHistory;
  final List<LeaveApplicationEntity> approvedLeave;
  final List<LeaveApplicationEntity> pendingLeave;

  final LeaveStatus status;
  final String message;

  const LeaveState({
    this.leaveHistory = const [],
    this.leaveApplicationHistory = const [],
    this.approvedLeave = const [],
    this.pendingLeave = const [],
    this.status = LeaveStatus.initial,
    this.message = '',
  });

  LeaveState copyWith({
    List<LeaveHistoryEntity>? leaveHistory,
    List<LeaveApplicationEntity>? leaveApplicationHistory,
    List<LeaveApplicationEntity>? approvedLeave,
    List<LeaveApplicationEntity>? pendingLeave,
    LeaveStatus? status,
    String? message,
  }) {
    return LeaveState(
      leaveHistory: leaveHistory ?? this.leaveHistory,
      leaveApplicationHistory:
          leaveApplicationHistory ?? this.leaveApplicationHistory,
      approvedLeave: approvedLeave ?? this.approvedLeave,
      pendingLeave: pendingLeave ?? this.pendingLeave,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    leaveHistory,
    leaveApplicationHistory,
    approvedLeave,
    pendingLeave,
    status,
    message,
  ];
}
