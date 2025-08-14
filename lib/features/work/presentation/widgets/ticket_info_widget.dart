import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketInfoWidget extends StatelessWidget {
  final TicketEntity ticket;

  const TicketInfoWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final dateTimeFormat = DateFormat('M/d/yyyy h:mm:ss a');

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ticket Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _buildInfoItem("Ticket Number", ticket.ticketNo.toUpperCase()),
                _buildInfoItem("Created On", dateFormat.format(ticket.issueOn)),
                _buildInfoItem(
                  "Ticket Status",
                  ticket.status,
                  valueColor: Colors.blue,
                ),
                _buildInfoItem("AssignedTo", ticket.assignedTo),
                _buildInfoItem("Registration No", ticket.ticketNo2),
                _buildInfoItem("Created By", ticket.issueBy),
                _buildInfoItem(
                  "Ticket Severity",
                  ticket.severity,
                  valueColor: Colors.red,
                ),
                _buildInfoItem(
                  "AssignedOn",
                  dateFormat.format(ticket.assignedOn),
                ),
                _buildInfoItem("Ticket Category", ticket.ticketCategoryName),
                _buildInfoItem(
                  "Priority",
                  ticket.priority,
                  valueColor: Colors.orange,
                ),
                _buildInfoItem(
                  "Last Modified On",
                  dateTimeFormat.format(ticket.updateTime ?? DateTime.now()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
    return SizedBox(
      width: 200, // Adjust width for responsiveness
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const Divider(height: 12, thickness: 0.5),
        ],
      ),
    );
  }
}
