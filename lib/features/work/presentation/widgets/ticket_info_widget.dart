import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:dynamic_emr/features/work/domain/entities/work_user_entity.dart';
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

                // Editable Assigned To
                _buildEditableItem(
                  context,
                  "Assigned To",
                  ticket.assignedTo,
                  onEdit: () {
                    _showAssignedToDialog(
                      context: context,
                      title: "Assign To",
                      users: user,
                      onSelected: (val) {
                        context.read<WorkBloc>().add(
                          EditAssignToEvent(
                            ticketId: ticket.id,
                            assignedUserId: val,
                          ),
                        );
                      },
                    );
                  },
                ),

                _buildInfoItem("Registration No", ticket.ticketNo2),
                _buildInfoItem("Created By", ticket.issueBy),

                // Editable Severity
                _buildEditableItem(
                  context,
                  "Ticket Severity",
                  ticket.severity,
                  valueColor: Colors.red,
                  onEdit: () => _showSeverityDialog(context, ticket),
                ),

                _buildInfoItem(
                  "Assigned On",
                  dateFormat.format(ticket.assignedOn),
                ),
                _buildInfoItem("Ticket Category", ticket.ticketCategoryName),

                // Editable Priority
                _buildEditableItem(
                  context,
                  "Priority",
                  ticket.priority,
                  valueColor: Colors.orange,
                  onEdit: () => _showPriorityDialog(context, ticket),
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
                    fontWeight: FontWeight.w500,
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
                        color: valueColor ?? Colors.black87,
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

  // Assigned to dialog
  void _showAssignedToDialog({
    required BuildContext context,
    required String title,
    required List<WorkUserEntity> users,
    required Function(int value) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: users.map((user) {
          return SimpleDialogOption(
            onPressed: () {
              onSelected(int.parse(user.value)); // 👈 sends "value" (id) only
              Navigator.pop(context);
            },
            child: Text(
              user.text, // 👈 shows "text" (label) only
              style: TextStyle(color: Colors.black.withValues(alpha: 0.8)),
            ),
          );
        }).toList(),
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
}
