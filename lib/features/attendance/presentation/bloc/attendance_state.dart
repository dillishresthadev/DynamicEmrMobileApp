part of 'attendance_bloc.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

final class AttendanceInitialState extends AttendanceState {}

final class AttendanceLoadingState extends AttendanceState {}

final class AttendanceDataState extends AttendanceState {
  final List<AttendanceEntity> primary;
  final List<AttendanceEntity> extended;

  const AttendanceDataState({
    this.primary = const [],
    this.extended = const [],
  });

  AttendanceDataState copyWith({
    List<AttendanceEntity>? primary,
    List<AttendanceEntity>? extended,
  }) {
    return AttendanceDataState(
      primary: primary ?? this.primary,
      extended: extended ?? this.extended,
    );
  }

  @override
  List<Object?> get props => [primary, extended];
}

final class AttendanceSummaryLoadedState extends AttendanceState {
  final AttendenceSummaryEntity attendanceSummary;

  const AttendanceSummaryLoadedState({required this.attendanceSummary});

  @override
  List<Object?> get props => [attendanceSummary];
}

final class AttendanceSummaryErrorState extends AttendanceState {
  final String errorMessage;

  const AttendanceSummaryErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

final class AttendanceCompleteState extends AttendanceState {
  final List<AttendanceEntity> primary;
  final List<AttendanceEntity> extended;
  final AttendenceSummaryEntity? attendanceSummary;

  const AttendanceCompleteState({
    this.primary = const [],
    this.extended = const [],
    this.attendanceSummary,
  });

  AttendanceCompleteState copyWith({
    List<AttendanceEntity>? primary,
    List<AttendanceEntity>? extended,
    AttendenceSummaryEntity? attendanceSummary,
  }) {
    return AttendanceCompleteState(
      primary: primary ?? this.primary,
      extended: extended ?? this.extended,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
    );
  }

  @override
  List<Object?> get props => [primary, extended, attendanceSummary];
}


final class AttendanceErrorState extends AttendanceState {
  final String errorMessage;

  const AttendanceErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
