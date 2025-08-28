import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketOverviewListWidget extends StatelessWidget {
  final List<TicketEntity> tickets;
  final void Function(TicketEntity) onTap;

  const TicketOverviewListWidget({
    required this.tickets,
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tickets.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _TicketCard(ticket: ticket, onTap: () => onTap(ticket));
      },
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final VoidCallback onTap;

  const _TicketCard({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildMetadata(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            ticket.ticketNo.toUpperCase(),
            style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
          ),
        ),
        _StatusBadge(status: ticket.status),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      ticket.title,
      style: TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.bold),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata() {
    final ticketDate = DateFormat(
      'EE dd MMM, yyyy hh:mm a',
    ).format(ticket.ticketDate);

    return Column(
      children: [
        Row(
          children: [
            _MetadataChip(
              icon: Icons.schedule_outlined,
              label: ticketDate,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            _MetadataChip(
              icon: Icons.account_circle_outlined,
              label: 'Created by: ${ticket.issueBy}',
              color: Colors.purple.shade600,
              // fullWidth: true,
            ),
            const SizedBox(width: 8),

            _MetadataChip(
              icon: Icons.person_outline,
              label: "Assigned to: ${ticket.assignedTo}",
              color: Colors.blue.shade600,
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            _MetadataChip(
              icon: Icons.flag_outlined,
              label: "Priority: ${ticket.priority}",
              color: _getPriorityColor(ticket.priority),
            ),
            const SizedBox(width: 8),
            _MetadataChip(
              icon: Icons.error_outline,
              label: "Severity: ${ticket.severity}",
              color: _getSeverityColor(ticket.severity),
            ),
          ],
        ),
        // if (ticket.issueBy.isNotEmpty) ...[
        //   const SizedBox(height: 8),
        //   _MetadataChip(
        //     icon: Icons.account_circle_outlined,
        //     label: 'Created by ${ticket.issueBy}',
        //     color: Colors.purple.shade600,
        //     fullWidth: true,
        //   ),
        // ],
      ],
    );
  }

  Color _getPriorityColor(String priority) {
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, backgroundColor) = _getStatusColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors() {
    switch (status.toLowerCase()) {
      case 'open':
        return (Colors.red.shade700, Colors.red.shade50);
      case 'closed':
        return (Colors.green.shade700, Colors.green.shade50);
      case 'in progress':
      case 'progress':
        return (Colors.blue.shade700, Colors.blue.shade50);
      case 'pending':
        return (Colors.orange.shade700, Colors.orange.shade50);
      default:
        return (Colors.grey.shade700, Colors.grey.shade50);
    }
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool fullWidth;

  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return fullWidth ? widget : Flexible(child: widget);
  }
}
