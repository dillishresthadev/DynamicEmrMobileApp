import 'package:dynamic_emr/core/extension/date_extension.dart';
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
    final leave = widget.leave;

    final hasPrimary = leave.fromDate != null && leave.toDate != null;
    final hasExtended =
        leave.extendedFromDate != null && leave.extendedToDate != null;

    String leaveType = "Primary";
    if (hasPrimary && hasExtended) {
      leaveType = "Both";
    } else if (hasExtended) {
      leaveType = "Extended";
    }

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
          /// --- Top Row: Status Icon + Leave Type + Status Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: leave.isApproved
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  leave.isApproved ? Icons.check_circle : Icons.schedule,
                  color: leave.isApproved ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasPrimary && hasExtended
                          ? '${leave.leaveTypeName} / ${leave.extendedLeaveTypeName}'
                          : hasExtended
                          ? leave.extendedLeaveTypeName ?? ''
                          : leave.leaveTypeName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      hasPrimary && hasExtended
                          ? 'Primary: ${leave.totalLeaveDays} day${leave.totalLeaveDays > 1 ? "s" : ""} + '
                                'Extended: ${leave.extendedTotalLeaveDays} day${leave.extendedTotalLeaveDays > 1 ? "s" : ""}'
                          : hasExtended
                          ? 'Duration: ${leave.extendedTotalLeaveDays} day${leave.extendedTotalLeaveDays > 1 ? "s" : ""}'
                          : 'Duration: ${leave.totalLeaveDays} day${leave.totalLeaveDays > 1 ? "s" : ""}',
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
                  color: leave.isApproved
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  leave.isApproved ? 'Approved' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: leave.isApproved
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// --- Dates Section
          if (hasPrimary && hasExtended) ...[
            _buildDateRow(
              'Primary',
              DateTime.parse(leave.fromDate).toDMMMYYYY(),
              DateTime.parse(leave.toDate).toDMMMYYYY(),
            ),
            const SizedBox(height: 8),
            _buildDateRow(
              'Extended',
              leave.extendedFromDate != null
                  ? DateTime.tryParse(leave.extendedFromDate!)?.toDMMMYYYY() ??
                        ''
                  : '',
              leave.extendedToDate != null
                  ? DateTime.tryParse(leave.extendedToDate!)?.toDMMMYYYY() ?? ''
                  : '',
            ),
          ] else if (hasExtended) ...[
            _buildDateRow(
              'Extended',
              leave.extendedFromDate != null
                  ? DateTime.tryParse(leave.extendedFromDate!)?.toDMMMYYYY() ??
                        ''
                  : '',
              leave.extendedToDate != null
                  ? DateTime.tryParse(leave.extendedToDate!)?.toDMMMYYYY() ?? ''
                  : '',
            ),
          ] else if (hasPrimary) ...[
            _buildDateRow(
              'Primary',
              DateTime.parse(leave.fromDate).toDMMMYYYY(),
              DateTime.parse(leave.toDate).toDMMMYYYY(),
            ),
          ],

          const SizedBox(height: 12),

          /// --- Application Date & Leave Number
          Row(
            children: [
              Icon(Icons.event_note, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Applied: ${DateTime.parse(leave.applicationDate).toDMMMYYYY()}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.confirmation_num,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Leave No: ${leave.leaveNo}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// --- Status Chips
          Row(
            children: [
              _StatusChip(
                label: leave.status,
                color: leave.status.toLowerCase() == 'open'
                    ? Colors.green.shade100
                    : leave.substitutationStatus.toLowerCase() == 'close'
                    ? Colors.red.shade100
                    : Colors.orange.shade100,
                textColor: leave.status.toLowerCase() == 'open'
                    ? Colors.green.shade800
                    : leave.status.toLowerCase() == 'close'
                    ? Colors.red.shade800
                    : Colors.orange.shade800,
              ),
              const SizedBox(width: 8),
              if (leave.leaveApprovedBy != null)
                _StatusChip(
                  label: 'Approved By: ${leave.leaveApprovedBy}',
                  color: Colors.green.shade100,
                  textColor: Colors.green.shade800,
                ),

              if (leave.rejectedBy != null)
                _StatusChip(
                  label: 'Rejected By: ${leave.rejectedBy}',
                  color: Colors.red.shade100,
                  textColor: Colors.red.shade800,
                ),

              const SizedBox(width: 8),
              _StatusChip(
                label: leaveType,
                color: Colors.blue.shade100,
                textColor: Colors.blue.shade800,
              ),
            ],
          ),

          /// --- Reason
          if (leave.reason.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Reason: ${leave.reason}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRow(String type, String from, String to) {
    return Row(
      children: [
        Icon(Icons.date_range, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          '$type From: $from',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Icon(Icons.date_range, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          'To: $to',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
