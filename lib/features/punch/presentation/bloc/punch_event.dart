part of 'punch_bloc.dart';

sealed class PunchEvent extends Equatable {
  const PunchEvent();

  @override
  List<Object> get props => [];
}

final class GetTodayPunchListEvent extends PunchEvent {}

final class TodayPunchEvent extends PunchEvent {
  final String long;
  final String lat;

  const TodayPunchEvent({required this.long, required this.lat});
  @override
  List<Object> get props => [long, lat];
}
