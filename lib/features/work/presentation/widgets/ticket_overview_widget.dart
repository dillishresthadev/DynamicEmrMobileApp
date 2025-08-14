import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketOverviewList extends StatelessWidget {
  final List<TicketEntity> tickets;

  const TicketOverviewList({required this.tickets, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tickets.length,
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        final ticketNo = ticket.ticketNo2;
        final title = ticket.title;
        final status = ticket.status;
        final priority = ticket.priority;
        final severity = ticket.severity;
        final assignedTo = ticket.assignedTo;
        final ticketDate = DateFormat('yyyy-MM-dd').format(ticket.ticketDate);

        Color statusColor;
        switch (status.toLowerCase()) {
          case 'open':
            statusColor = Colors.green;
            break;
          case 'closed':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.grey;
        }

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket No & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ticketNo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Title
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 12),
                // Priority, Severity, Assigned To
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip('Priority', priority, Colors.orange),
                    _infoChip('Severity', severity, Colors.redAccent),
                    _infoChip('Assigned', assignedTo, Colors.blueAccent),
                  ],
                ),
                SizedBox(height: 12),
                // Date
                Text(
                  'Date: $ticketDate',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
