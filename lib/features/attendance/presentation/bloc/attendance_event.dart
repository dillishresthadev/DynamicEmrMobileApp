part of 'attendance_bloc.dart';

sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

final class GetCurrentMonthAttendancePrimaryEvent extends AttendanceEvent {}

final class GetCurrentMonthAttendanceExtendedEvent extends AttendanceEvent {}

final class GetAttendanceSummaryEvent extends AttendanceEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String shiftType;

  const GetAttendanceSummaryEvent({
    required this.fromDate,
    required this.toDate,
    required this.shiftType,
  });
  @override
  List<Object> get props => [fromDate, toDate, shiftType];
}
