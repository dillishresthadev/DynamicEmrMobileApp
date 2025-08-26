part of 'leave_bloc.dart';

sealed class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object> get props => [];
}

final class LeaveHistoryEvent extends LeaveEvent {}

final class GetContractEvent extends LeaveEvent {}

final class GetFiscalYearByContractIdEvent extends LeaveEvent {
  final int contractId;

  const GetFiscalYearByContractIdEvent({required this.contractId});
  @override
  List<Object> get props => [contractId];
}

final class GetLeaveHistoryByContractIdFiscalYearIdEvent extends LeaveEvent {
  final int contractId;
  final int fiscalYearId;

  const GetLeaveHistoryByContractIdFiscalYearIdEvent({
    required this.contractId,
    required this.fiscalYearId,
  });
  @override
  List<Object> get props => [contractId, fiscalYearId];
}

final class LeaveApplicationHistoryEvent extends LeaveEvent {
  final int contractId;
  final int fiscalYearId;

  const LeaveApplicationHistoryEvent({
    required this.contractId,
    required this.fiscalYearId,
  });

  @override
  List<Object> get props => [contractId, fiscalYearId];
}

final class ApprovedLeaveListEvent extends LeaveEvent {}

final class PendingLeaveListEvent extends LeaveEvent {}

final class LeaveTypeEvent extends LeaveEvent {}

final class LeaveTypeExtendedEvent extends LeaveEvent {}

final class SubstitutionEmployeeEvent extends LeaveEvent {}

final class ApplyLeaveEvent extends LeaveEvent {
  final LeaveApplicationRequestEntity leaveRequest;

  const ApplyLeaveEvent({required this.leaveRequest});
  @override
  List<Object> get props => [leaveRequest];
}
