import 'package:flutter/material.dart';

class LeaveCardWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String availableLeaaveCount;
  // final String totalLeaveCount;
  final String label;

  const LeaveCardWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.availableLeaaveCount,
    // required this.totalLeaveCount,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    availableLeaaveCount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    child: Text(
                      label,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: color, size: 42),
          ],
        ),
      ),
    );
  }
}
