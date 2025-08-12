part of 'attendance_bloc.dart';

enum AttendanceStatus {
  initial,
  loading,
  loadPrimarySuccess,
  loadPrimaryError,
  loadExtendedSuccess,
  loadExtendedError,
  loadSummarySuccess,
  loadSummaryError,
}

final class AttendanceState extends Equatable {
  final List<AttendanceEntity> primary;
  final List<AttendanceEntity> extended;
  final AttendenceSummaryEntity? summary;
  final AttendanceStatus status;
  final String message;

  const AttendanceState({
    this.primary = const [],
    this.extended = const [],
    this.summary,
    this.status = AttendanceStatus.initial,
    this.message = '',
  });

  AttendanceState copyWith({
    List<AttendanceEntity>? primary,
    List<AttendanceEntity>? extended,
    AttendenceSummaryEntity? summary,
    AttendanceStatus? status,
    String? message,
  }) {
    return AttendanceState(
      primary: primary ?? this.primary,
      extended: extended ?? this.extended,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        primary,
        extended,
        summary,
        status,
        message,
      ];
}
