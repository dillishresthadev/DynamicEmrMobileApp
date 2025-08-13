import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';

class TicketSummaryModel extends TicketSummaryEntity {
  TicketSummaryModel({
    required super.open,
    required super.inProgress,
    required super.closed,
    required super.severityHigh,
    required super.severityMedium,
    required super.severityLow,
    required super.priorityHigh,
    required super.priorityMedium,
    required super.priorityLow,
    required super.averageCompletionRatePerDay,
  });

  factory TicketSummaryModel.fromJson(Map<String, dynamic> json) {
    return TicketSummaryModel(
      open: json['open'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      closed: json['closed'] ?? 0,
      severityHigh: json['severityHigh'] ?? 0,
      severityMedium: json['severityMedium'] ?? 0,
      severityLow: json['severityLow'] ?? 0,
      priorityHigh: json['priorityHigh'] ?? 0,
      priorityMedium: json['priorityMedium'] ?? 0,
      priorityLow: json['priorityLow'] ?? 0,
      averageCompletionRatePerDay:
          json['averageCompletionRatePerDay']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'inProgress': inProgress,
      'closed': closed,
      'severityHigh': severityHigh,
      'severityMedium': severityMedium,
      'severityLow': severityLow,
      'priorityHigh': priorityHigh,
      'priorityMedium': priorityMedium,
      'priorityLow': priorityLow,
      'averageCompletionRatePerDay': averageCompletionRatePerDay,
    };
  }
}
