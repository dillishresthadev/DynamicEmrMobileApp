import 'package:dynamic_emr/features/attendance/domain/entities/attendance_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceDetailsCardWidget extends StatelessWidget {
  final AttendanceDetailsEntity attendanceDetails;
  const AttendanceDetailsCardWidget({
    super.key,
    required this.attendanceDetails,
  });

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF3B82F6)).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: iconColor ?? const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(String title, String time, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime? time) =>
      time != null ? DateFormat('hh:mm a').format(time) : '--:--';

  String calculateWorkedHours(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) return '-- --';
    final duration = checkOut.difference(checkIn);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m";
  }

  Color _getStatusColor() {
    if (attendanceDetails.statusColorCode.startsWith("#") &&
        attendanceDetails.statusColorCode.length == 7) {
      return Color(
        int.parse(attendanceDetails.statusColorCode.replaceFirst("#", "0xFF")),
      );
    }
    return const Color(0xFF10B981); // Default green
  }

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(attendanceDetails.attendanceDate.toString()) ??
        DateTime.now();
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Date Circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd').format(date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Date and Shift Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(date),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        attendanceDetails.shiftTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendanceDetails.status.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Time Cards Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Check In/Out Times
                Row(
                  children: [
                    _buildTimeCard(
                      'CHECK IN',
                      formatTime(attendanceDetails.checkInTime),
                      const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    _buildTimeCard(
                      'CHECK OUT',
                      formatTime(attendanceDetails.checkOutTime),
                      const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 8),
                    _buildTimeCard(
                      'WORKED',
                      calculateWorkedHours(
                        attendanceDetails.checkInTime,
                        attendanceDetails.checkOutTime,
                      ),
                      const Color(0xFF8B5CF6),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Additional Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildInfoRow(
                    Icons.schedule_rounded,
                    'Scheduled Shift',
                    "${formatTime(attendanceDetails.shiftStartTime)} - ${formatTime(attendanceDetails.shiftEndTime)}",
                    iconColor: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
