class TicketSummaryEntity {
  final int open;
  final int inProgress;
  final int closed;
  final int severityHigh;
  final int severityMedium;
  final int severityLow;
  final int priorityHigh;
  final int priorityMedium;
  final int priorityLow;
  final double averageCompletionRatePerDay;

  TicketSummaryEntity({
    required this.open,
    required this.inProgress,
    required this.closed,
    required this.severityHigh,
    required this.severityMedium,
    required this.severityLow,
    required this.priorityHigh,
    required this.priorityMedium,
    required this.priorityLow,
    required this.averageCompletionRatePerDay,
  });
}
