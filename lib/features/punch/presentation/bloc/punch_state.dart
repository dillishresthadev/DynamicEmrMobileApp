part of 'punch_bloc.dart';

enum PunchStatus { initial, loading, success, error }

final class PunchState extends Equatable {
  final List<EmployeePunchEntity> punchList;
  final PunchStatus status;
  final String message;

  const PunchState({
    this.punchList = const [],
    this.status = PunchStatus.initial,
    this.message = '',
  });

  PunchState copyWith({
    List<EmployeePunchEntity>? punchList,
    PunchStatus? status,
    String? message,
  }) {
    return PunchState(
      punchList: punchList ?? this.punchList,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [punchList, status, message];
}
