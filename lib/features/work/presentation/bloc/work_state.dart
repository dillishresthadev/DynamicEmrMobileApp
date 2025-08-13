part of 'work_bloc.dart';

enum WorkStatus {
  initial,
  loading,
  success,
  createTicketSuccess,
  createTicketError,
  error,
}

final class WorkState extends Equatable {
  final TicketSummaryEntity? myTicketSummary;
  final TicketSummaryEntity? ticketAssignedToMeSummary;
  final List<TicketCategoriesEntity>? ticketCategories;
  final List<WorkUserEntity>? workUser;

  final WorkStatus myTicketStatus;
  final WorkStatus assignedTicketStatus;

  final WorkStatus workStatus;

  final String myTicketMessage;
  final String assignedTicketMessage;
  final String message;

  final bool createTicket;

  const WorkState({
    this.myTicketSummary,
    this.ticketAssignedToMeSummary,
    this.ticketCategories,
    this.workUser,
    this.createTicket = false,
    this.myTicketStatus = WorkStatus.initial,
    this.assignedTicketStatus = WorkStatus.initial,
    this.workStatus = WorkStatus.initial,
    this.myTicketMessage = '',
    this.assignedTicketMessage = '',
    this.message = '',
  });

  WorkState copyWith({
    TicketSummaryEntity? myTicketSummary,
    TicketSummaryEntity? ticketAssignedToMeSummary,
    WorkStatus? myTicketStatus,
    WorkStatus? assignedTicketStatus,
    WorkStatus? workStatus,
    String? myTicketMessage,
    String? assignedTicketMessage,
    bool? createTicket,
    List<TicketCategoriesEntity>? ticketCategories,
    List<WorkUserEntity>? workUser,
    String? message,
  }) {
    return WorkState(
      myTicketSummary: myTicketSummary ?? this.myTicketSummary,
      ticketAssignedToMeSummary:
          ticketAssignedToMeSummary ?? this.ticketAssignedToMeSummary,
      myTicketStatus: myTicketStatus ?? this.myTicketStatus,
      workStatus: workStatus ?? this.workStatus,
      assignedTicketStatus: assignedTicketStatus ?? this.assignedTicketStatus,
      myTicketMessage: myTicketMessage ?? this.myTicketMessage,
      assignedTicketMessage:
          assignedTicketMessage ?? this.assignedTicketMessage,
      createTicket: createTicket ?? this.createTicket,
      ticketCategories: ticketCategories ?? this.ticketCategories,
      workUser: workUser ?? this.workUser,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    myTicketSummary,
    ticketAssignedToMeSummary,
    myTicketStatus,
    assignedTicketStatus,
    createTicket,
    workStatus,
    myTicketMessage,
    assignedTicketMessage,
    ticketCategories,
    workUser,
    message,
  ];
}
