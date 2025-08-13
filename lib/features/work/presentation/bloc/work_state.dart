part of 'work_bloc.dart';

enum WorkStatus { initial, loading, success, error }

final class WorkState extends Equatable {
  final TicketSummaryEntity? myTicketSummary;
  final TicketSummaryEntity? ticketAssignedToMeSummary;

  final WorkStatus myTicketStatus;
  final WorkStatus assignedTicketStatus;

  final String myTicketMessage;
  final String assignedTicketMessage;

  const WorkState({
    this.myTicketSummary,
    this.ticketAssignedToMeSummary,
    this.myTicketStatus = WorkStatus.initial,
    this.assignedTicketStatus = WorkStatus.initial,
    this.myTicketMessage = '',
    this.assignedTicketMessage = '',
  });

  WorkState copyWith({
    TicketSummaryEntity? myTicketSummary,
    TicketSummaryEntity? ticketAssignedToMeSummary,
    WorkStatus? myTicketStatus,
    WorkStatus? assignedTicketStatus,
    String? myTicketMessage,
    String? assignedTicketMessage,
  }) {
    return WorkState(
      myTicketSummary: myTicketSummary ?? this.myTicketSummary,
      ticketAssignedToMeSummary:
          ticketAssignedToMeSummary ?? this.ticketAssignedToMeSummary,
      myTicketStatus: myTicketStatus ?? this.myTicketStatus,
      assignedTicketStatus: assignedTicketStatus ?? this.assignedTicketStatus,
      myTicketMessage: myTicketMessage ?? this.myTicketMessage,
      assignedTicketMessage:
          assignedTicketMessage ?? this.assignedTicketMessage,
    );
  }

  @override
  List<Object?> get props => [
    myTicketSummary,
    ticketAssignedToMeSummary,
    myTicketStatus,
    assignedTicketStatus,
    myTicketMessage,
    assignedTicketMessage,
  ];
}
