part of 'work_bloc.dart';

enum WorkStatus {
  initial,
  loading,
  success,
  createTicketSuccess,
  createTicketError,
  ticketDetailsLoadSuccess,
  ticketDetailsError,
  ticketReOpenSuccess,
  ticketReOpenError,
  ticketClosedSuccess,
  ticketClosedError,
  commentOnTicketSuccess,
  commentOnTicketError,
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

  final List<TicketEntity>? filterMyTicket;
  final List<TicketEntity>? filterMyAssignedTicket;
  final WorkStatus filterMyTicketStatus;
  final WorkStatus filterAssignedTicketStatus;
  final String filterMyTicketMessage;
  final String filterMyAssignedTicketMessage;

  final TicketDetailsEntity? ticketDetails;

  final bool reOpenTicket;
  final bool closeTicket;
  final bool commentOnTicket;

  const WorkState({
    this.myTicketSummary,
    this.ticketAssignedToMeSummary,
    this.ticketCategories,
    this.workUser,
    this.filterMyTicket,
    this.filterMyAssignedTicket,
    this.ticketDetails,
    this.createTicket = false,
    this.reOpenTicket = false,
    this.closeTicket = false,
    this.commentOnTicket = false,
    this.myTicketStatus = WorkStatus.initial,
    this.assignedTicketStatus = WorkStatus.initial,
    this.filterMyTicketStatus = WorkStatus.initial,
    this.filterAssignedTicketStatus = WorkStatus.initial,
    this.workStatus = WorkStatus.initial,
    this.myTicketMessage = '',
    this.assignedTicketMessage = '',
    this.filterMyTicketMessage = '',
    this.filterMyAssignedTicketMessage = '',
    this.message = '',
  });

  WorkState copyWith({
    TicketSummaryEntity? myTicketSummary,
    TicketSummaryEntity? ticketAssignedToMeSummary,
    WorkStatus? myTicketStatus,
    WorkStatus? assignedTicketStatus,
    WorkStatus? filterMyTicketStatus,
    WorkStatus? filterAssignedTicketStatus,
    WorkStatus? workStatus,
    String? myTicketMessage,
    String? assignedTicketMessage,
    String? filterMyTicketMessage,
    String? filterMyAssignedTicketMessage,
    bool? createTicket,
    bool? reOpenTicket,
    bool? closeTicket,
    bool? commentOnTicket,
    List<TicketCategoriesEntity>? ticketCategories,
    List<WorkUserEntity>? workUser,
    List<TicketEntity>? filterMyTicket,
    List<TicketEntity>? filterMyAssignedTicket,
    TicketDetailsEntity? ticketDetails,
    String? message,
  }) {
    return WorkState(
      myTicketSummary: myTicketSummary ?? this.myTicketSummary,
      ticketAssignedToMeSummary:
          ticketAssignedToMeSummary ?? this.ticketAssignedToMeSummary,
      myTicketStatus: myTicketStatus ?? this.myTicketStatus,
      workStatus: workStatus ?? this.workStatus,
      assignedTicketStatus: assignedTicketStatus ?? this.assignedTicketStatus,
      filterMyTicketStatus: filterMyTicketStatus ?? this.filterMyTicketStatus,
      filterAssignedTicketStatus:
          filterAssignedTicketStatus ?? this.filterAssignedTicketStatus,
      myTicketMessage: myTicketMessage ?? this.myTicketMessage,
      assignedTicketMessage:
          assignedTicketMessage ?? this.assignedTicketMessage,
      filterMyTicketMessage:
          filterMyTicketMessage ?? this.filterMyTicketMessage,
      filterMyAssignedTicketMessage:
          filterMyAssignedTicketMessage ?? this.filterMyAssignedTicketMessage,
      createTicket: createTicket ?? this.createTicket,
      ticketCategories: ticketCategories ?? this.ticketCategories,
      workUser: workUser ?? this.workUser,
      filterMyTicket: filterMyTicket ?? this.filterMyTicket,
      filterMyAssignedTicket:
          filterMyAssignedTicket ?? this.filterMyAssignedTicket,
      ticketDetails: ticketDetails ?? this.ticketDetails,
      message: message ?? this.message,
      reOpenTicket: reOpenTicket ?? this.reOpenTicket,
      closeTicket: closeTicket ?? this.closeTicket,
      commentOnTicket: commentOnTicket?? this.commentOnTicket,
    );
  }

  @override
  List<Object?> get props => [
    myTicketSummary,
    ticketAssignedToMeSummary,
    myTicketStatus,
    assignedTicketStatus,
    filterMyTicketStatus,
    filterAssignedTicketStatus,
    createTicket,
    workStatus,
    myTicketMessage,
    assignedTicketMessage,
    filterMyTicketMessage,
    filterMyAssignedTicketMessage,
    ticketCategories,
    workUser,
    filterMyTicket,
    filterMyAssignedTicket,
    ticketDetails,
    message,
    reOpenTicket,
    closeTicket,
    commentOnTicket,
  ];
}
