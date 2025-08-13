part of 'work_bloc.dart';

sealed class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object> get props => [];
}

final class MyTicketSummaryEvent extends WorkEvent{}
final class TicketAssignedToMeSummaryEvent extends WorkEvent{}
