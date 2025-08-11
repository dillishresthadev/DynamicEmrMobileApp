import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:flutter/material.dart';

class LeaveApplicationCardWidget extends StatefulWidget {
  final LeaveApplicationEntity leave;
  const LeaveApplicationCardWidget({super.key, required this.leave});

  @override
  State<LeaveApplicationCardWidget> createState() =>
      _LeaveApplicationCardWidgetState();
}

class _LeaveApplicationCardWidgetState
    extends State<LeaveApplicationCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.leave.isApproved
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.leave.isApproved ? Icons.check_circle : Icons.schedule,
                  color: widget.leave.isApproved ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.leave.leaveTypeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Duration: ${widget.leave.totalLeaveDays} days',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.leave.isApproved
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.leave.isApproved ? 'Approved' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.leave.isApproved
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.date_range, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'From: ${widget.leave.fromDate}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              Icon(Icons.date_range, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'To: ${widget.leave.toDate}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          if (widget.leave.reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Reason: ${widget.leave.reason}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
