import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
import 'package:dynamic_emr/features/work/presentation/widgets/assign_to_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/work_bloc.dart';

class TicketInfoWidget extends StatelessWidget {
  final TicketEntity ticket;
  final List<WorkUserEntity> user;

  const TicketInfoWidget({super.key, required this.ticket, required this.user});

  @override
  Widget build(BuildContext context) {
    final dateTimeFormat = DateFormat('M/d/yyyy h:mm:ss a');

    final createdOnDate = DateFormat(
      'EE dd MMM, yyyy hh:mm a',
    ).format(ticket.issueOn);
    final assignOnDate = DateFormat(
      'EE dd MMM, yyyy hh:mm a',
    ).format(ticket.assignedOn);

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ticket Information"),
                Text(ticket.ticketNo.toUpperCase()),
              ],
            ),
            // Text(
            //   "Ticket Information ${ticket.ticketNo.toUpperCase()}",
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 2,
              children: [
                // _buildInfoItem("Ticket Number"),
                _buildInfoItem("Registration No", ticket.ticketNo2),
                _buildInfoItem(
                  "Ticket Category",
                  ticket.ticketCategoryName,
                  fontWeight: FontWeight.bold,
                ),

                _buildInfoItem("Created On", createdOnDate),
                _buildInfoItem("Created By", ticket.issueBy),
                AssignToBottomSheetWidget(users: user, ticket: ticket),
                _buildInfoItem("Assigned On", assignOnDate),

                // Editable Severity
                _buildEditableItem(
                  context,
                  "Ticket Severity",
                  ticket.severity,
                  valueColor: Colors.green,
                  onEdit: () => _showSeverityDialog(context, ticket),
                ),

                // Editable Priority
                _buildEditableItem(
                  context,
                  "Priority",
                  ticket.priority,
                  valueColor: Colors.green,
                  onEdit: () => _showPriorityDialog(context, ticket),
                ),
                _buildInfoItem(
                  "Ticket Status",
                  ticket.status,
                  valueColor: Colors.blue,
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

  Widget _buildInfoItem(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? fontWeight,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: fontWeight,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 12, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildEditableItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    required VoidCallback onEdit,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _getValueColor(value.toLowerCase()),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.edit, size: 16, color: Colors.blueGrey),
                  ],
                ),
              ],
            ),
            const Divider(height: 12, thickness: 0.5),
          ],
        ),
      ),
    );
  }

  /// Priority Dialog
  void _showPriorityDialog(BuildContext context, TicketEntity ticket) {
    final priorities = ["Low", "Medium", "High"];
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Edit Priority"),
        children: priorities
            .map(
              (p) => SimpleDialogOption(
                onPressed: () {
                  context.read<WorkBloc>().add(
                    EditPriorityEvent(ticketId: ticket.id, status: p),
                  );
                  Navigator.pop(context);
                },
                child: Text(p),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Severity Dialog
  void _showSeverityDialog(BuildContext context, TicketEntity ticket) {
    final severities = ["Low", "High", "Medium"];
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Edit Severity"),
        children: severities
            .map(
              (s) => SimpleDialogOption(
                onPressed: () {
                  context.read<WorkBloc>().add(
                    EditSeverityEvent(ticketId: ticket.id, status: s),
                  );
                  Navigator.pop(context);
                },
                child: Text(s),
              ),
            )
            .toList(),
      ),
    );
  }

  Color _getValueColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade600;
      case 'low':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
