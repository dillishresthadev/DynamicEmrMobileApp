part of 'work_bloc.dart';

sealed class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object?> get props => [];
}

final class MyTicketSummaryEvent extends WorkEvent {}

final class TicketAssignedToMeSummaryEvent extends WorkEvent {}

final class WorkUserListEvent extends WorkEvent {}

final class BusinessClientEvent extends WorkEvent {}

final class TicketCategoriesEvent extends WorkEvent {}

final class TicketReopenEvent extends WorkEvent {
  final int ticketId;

  const TicketReopenEvent({required this.ticketId});
  @override
  List<Object?> get props => [ticketId];
}

final class TicketClosedEvent extends WorkEvent {
  final int ticketId;

  const TicketClosedEvent({required this.ticketId});
  @override
  List<Object?> get props => [ticketId];
}

final class CommentOnTicketEvent extends WorkEvent {
  final int ticketId;
  final String message;
  final List<String>? attachmentPaths;

  const CommentOnTicketEvent({
    required this.ticketId,
    required this.message,
    this.attachmentPaths,
  });
  @override
  List<Object?> get props => [ticketId, message];
}

final class TicketDetailsByIdEvent extends WorkEvent {
  final int ticketId;

  const TicketDetailsByIdEvent({required this.ticketId});
  @override
  List<Object?> get props => [ticketId];
}

final class CreateTicketEvent extends WorkEvent {
  final int ticketCategoryId;
  final String title;
  final String description;
  final String severity;
  final String priority;
  final String client;
  final String clientDesc;
  final String clientDesc2;
  final String dueDate;
  final int assignToEmployeeId;
  final List<String>? attachmentPaths;

  const CreateTicketEvent({
    required this.ticketCategoryId,
    required this.title,
    required this.description,
    required this.severity,
    required this.priority,
    required this.client,
    required this.clientDesc,
    required this.clientDesc2,
    required this.dueDate,
    required this.assignToEmployeeId,
    this.attachmentPaths,
  });
  @override
  List<Object?> get props => [
    ticketCategoryId,
    title,
    description,
    severity,
    priority,
    client,
    clientDesc,
    clientDesc2,
    assignToEmployeeId,
    attachmentPaths,
  ];
}

final class FilterMyTicketEvent extends WorkEvent {
  final int ticketCategoryId;
  final String status;
  final String priority;
  final String severity;
  final String assignTo;
  final String fromDate;
  final String toDate;
  final String orderBy;

  const FilterMyTicketEvent({
    required this.ticketCategoryId,
    required this.status,
    required this.priority,
    required this.severity,
    required this.assignTo,
    required this.fromDate,
    required this.toDate,
    required this.orderBy,
  });
  @override
  List<Object> get props => [
    ticketCategoryId,
    status,
    priority,
    severity,
    assignTo,
    fromDate,
    toDate,
    orderBy,
  ];
}

final class FilterTicketAssignedToMeEvent extends WorkEvent {
  final int ticketCategoryId;
  final String status;
  final String priority;
  final String severity;
  final String assignTo;
  final String fromDate;
  final String toDate;
  final String orderBy;

  const FilterTicketAssignedToMeEvent({
    required this.ticketCategoryId,
    required this.status,
    required this.priority,
    required this.severity,
    required this.assignTo,
    required this.fromDate,
    required this.toDate,
    required this.orderBy,
  });
  @override
  List<Object> get props => [
    ticketCategoryId,
    status,
    priority,
    severity,
    assignTo,
    fromDate,
    toDate,
    orderBy,
  ];
}

final class EditTicketEvent extends WorkEvent {
  final TicketEntity ticket;

  const EditTicketEvent({required this.ticket});
}

final class EditPriorityEvent extends WorkEvent {
  final int ticketId;
  final String status;

  const EditPriorityEvent({required this.ticketId, required this.status});
  @override
  List<Object> get props => [ticketId, status];
}

final class EditSeverityEvent extends WorkEvent {
  final int ticketId;
  final String status;

  const EditSeverityEvent({required this.ticketId, required this.status});
  @override
  List<Object> get props => [ticketId, status];
}

final class EditAssignToEvent extends WorkEvent {
  final int ticketId;
  final int assignedUserId;

  const EditAssignToEvent({
    required this.ticketId,
    required this.assignedUserId,
  });
  @override
  List<Object> get props => [ticketId, assignedUserId];
}
