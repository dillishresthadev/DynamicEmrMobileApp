part of 'work_bloc.dart';

sealed class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object> get props => [];
}

final class MyTicketSummaryEvent extends WorkEvent {}

final class TicketAssignedToMeSummaryEvent extends WorkEvent {}

final class WorkUserListEvent extends WorkEvent {}

final class TicketCategoriesEvent extends WorkEvent {}

final class CreateTicketEvent extends WorkEvent {
  final int ticketCategoryId;
  final String title;
  final String description;
  final String severity;
  final String priority;
  final int assignToEmployeeId;
  final List<String>? attachmentPaths;

  const CreateTicketEvent({
    required this.ticketCategoryId,
    required this.title,
    required this.description,
    required this.severity,
    required this.priority,
    required this.assignToEmployeeId,
    required this.attachmentPaths,
  });
}
