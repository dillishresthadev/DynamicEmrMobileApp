import 'package:dynamic_emr/features/work/domain/entities/ticket_summary_entity.dart';
import 'package:flutter/material.dart';

class WorkCompletionRateCardWidget extends StatelessWidget {
  final TicketSummaryEntity ticketSummary;
  const WorkCompletionRateCardWidget({super.key, required this.ticketSummary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1E3A8A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.trending_up, color: Color(0xFF1E3A8A), size: 32),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Completion Rate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  '${ticketSummary.averageCompletionRatePerDay.toStringAsFixed(1)} tickets/day',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Based on last 30 days',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
