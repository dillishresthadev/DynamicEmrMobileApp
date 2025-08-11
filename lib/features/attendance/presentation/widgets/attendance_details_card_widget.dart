import 'package:dynamic_emr/features/attendance/domain/entities/attendance_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceDetailsCardWidget extends StatelessWidget {
  final AttendanceDetailsEntity attendanceDetails;
  const AttendanceDetailsCardWidget({
    super.key,
    required this.attendanceDetails,
  });

  Widget _buildActivityDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(attendanceDetails.attendanceDate.toString()) ??
        DateTime.now();

    String formatTime(DateTime? time) =>
        time != null ? DateFormat('hh:mm a').format(time) : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Status
                Text(
                  attendanceDetails.shiftTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            attendanceDetails.statusColorCode.startsWith("#") &&
                                attendanceDetails.statusColorCode.length == 7
                            ? Color(
                                int.parse(
                                  attendanceDetails.statusColorCode
                                      .replaceFirst("#", "0xFF"),
                                ),
                              )
                            : null,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        attendanceDetails.statusFullName.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Check In, Check Out, Duty/shift Type
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityDetail(
                        'Check In / Out',
                        "${formatTime(attendanceDetails.checkInTime)} - ${formatTime(attendanceDetails.checkOutTime)}",
                      ),
                    ),
                    Expanded(
                      child: _buildActivityDetail(
                        'Shift Time',
                        "${formatTime(attendanceDetails.shiftStartTime)} - ${formatTime(attendanceDetails.shiftEndTime)}",
                      ),
                    ),
                    // Expanded(
                    //   child: _buildActivityDetail(
                    //     "Type",
                    //     attendanceDetails.dutyType.toString(),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
