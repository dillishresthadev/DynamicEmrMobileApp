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
  applyLeaveSuccess,
  applyLeaveError,
  leaveTypeSuccess,
  leaveTypeError,
  extendedLeaveTypeSuccess,
  extendedLeaveTypeError,
  substitutionEmployeeSuccess,
  substitutionEmployeeError,
}

final class LeaveState extends Equatable {
  final List<LeaveHistoryEntity> leaveHistory;
  final List<LeaveApplicationEntity> leaveApplicationHistory;
  final List<LeaveApplicationEntity> approvedLeave;
  final List<LeaveApplicationEntity> pendingLeave;
  final bool applyLeave;
  final List<LeaveTypeEntity> leaveType;
  final List<LeaveTypeEntity> extendedLeaveType;
  final List<LeaveTypeEntity> substitutionEmployee;
  final LeaveStatus status;
  final LeaveStatus approvedLeaveStatus;
  final LeaveStatus pendingLeaveStatus;
  final String message;
  final String approvedLeaveMessage;
  final String pendingLeaveMessage;

  const LeaveState({
    this.leaveHistory = const [],
    this.leaveApplicationHistory = const [],
    this.approvedLeave = const [],
    this.pendingLeave = const [],
    this.status = LeaveStatus.initial,
    this.approvedLeaveStatus = LeaveStatus.initial,
    this.pendingLeaveStatus = LeaveStatus.initial,
    this.message = '',
    this.approvedLeaveMessage = '',
    this.pendingLeaveMessage = '',
    this.applyLeave = false,
    this.leaveType = const [],
    this.extendedLeaveType = const [],
    this.substitutionEmployee = const [],
  });

  LeaveState copyWith({
    List<LeaveHistoryEntity>? leaveHistory,
    List<LeaveApplicationEntity>? leaveApplicationHistory,
    List<LeaveApplicationEntity>? approvedLeave,
    List<LeaveApplicationEntity>? pendingLeave,
    final List<LeaveTypeEntity>? leaveType,
    final List<LeaveTypeEntity>? extendedLeaveType,
    final List<LeaveTypeEntity>? substitutionEmployee,
    bool? applyLeave,
    LeaveStatus? approvedLeaveStatus,
    LeaveStatus? pendingLeaveStatus,
    LeaveStatus? status,
    String? approvedLeaveMessage,
    String? pendingLeaveMessage,
    String? message,
  }) {
    return LeaveState(
      leaveHistory: leaveHistory ?? this.leaveHistory,
      leaveApplicationHistory:
          leaveApplicationHistory ?? this.leaveApplicationHistory,
      approvedLeave: approvedLeave ?? this.approvedLeave,
      pendingLeave: pendingLeave ?? this.pendingLeave,
      leaveType: leaveType ?? this.leaveType,
      extendedLeaveType: extendedLeaveType ?? this.extendedLeaveType,
      substitutionEmployee: substitutionEmployee ?? this.substitutionEmployee,
      applyLeave: applyLeave ?? this.applyLeave,
      approvedLeaveStatus: approvedLeaveStatus ?? this.approvedLeaveStatus,
      pendingLeaveStatus: pendingLeaveStatus ?? this.pendingLeaveStatus,
      status: status ?? this.status,
      approvedLeaveMessage: approvedLeaveMessage ?? this.approvedLeaveMessage,
      pendingLeaveMessage: pendingLeaveMessage ?? this.pendingLeaveMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    leaveHistory,
    leaveApplicationHistory,
    approvedLeave,
    pendingLeave,
    leaveType,
    extendedLeaveType,
    substitutionEmployee,
    applyLeave,
    status,
    message,
  ];
}
