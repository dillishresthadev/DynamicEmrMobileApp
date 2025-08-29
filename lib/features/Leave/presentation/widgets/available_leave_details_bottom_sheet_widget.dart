import 'package:flutter/material.dart';
import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_history_entity.dart';

class AvailableLeaveDetailsBottomSheetWidget extends StatelessWidget {
  final LeaveHistoryEntity leave;
  final Map<String, dynamic> config;

  const AvailableLeaveDetailsBottomSheetWidget({
    super.key,
    required this.leave,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 2.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 5, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: (config['bgColor'] as Color),
                      child: Icon(config['icon'], color: config['color']),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      leave.leaveType,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Info Tiles
                _LeaveInfoTile(
                  label: "Allocated",
                  value: leave.allocated.toString(),
                  icon: Icons.assignment,
                  color: AppColors.primary,
                ),
                _LeaveInfoTile(
                  label: "Taken",
                  value: leave.taken.toString(),
                  icon: Icons.event_busy,
                  color: Colors.red,
                ),
                _LeaveInfoTile(
                  label: "Remaining",
                  value: leave.balance.toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),

                const SizedBox(height: 12),

                // Close Button
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LeaveInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _LeaveInfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
