import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayAttendanceWidget extends StatefulWidget {
  const TodayAttendanceWidget({super.key});

  @override
  State<TodayAttendanceWidget> createState() => _TodayAttendanceWidgetState();
}

class _TodayAttendanceWidgetState extends State<TodayAttendanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state.status == AttendanceStatus.loadSummarySuccess) {
            return _buildAttendanceCard(state);
          }
          return _buildAttendanceLoadingCard();
        },
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceState state) {
    final attendance = state.summary;
    final today = DateTime.now();

    final todaysAttendanceList = attendance?.attendanceDetails.where((detail) {
      final attendanceDate = detail.attendanceDate;
      return attendanceDate.year == today.year &&
          attendanceDate.month == today.month &&
          attendanceDate.day == today.day;
    }).toList();

    if (todaysAttendanceList == null || todaysAttendanceList.isEmpty) {
      return _buildNoAttendanceCard();
    }

    final todayAttendance = todaysAttendanceList.first;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Attendance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      todayAttendance.attendanceDateNp,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(todayAttendance),
            ],
          ),
          const SizedBox(height: 20),

          // Show Check In button if not already checked in
          if (todayAttendance.checkInTime == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  "Check In",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  // Check In logic
                },
              ),
            ),

          // Show Check Out button if checked in but not checked out
          if (todayAttendance.checkInTime != null &&
              todayAttendance.checkOutTime == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  // Check Out logic
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(todayAttendance) {
    final isPresent = todayAttendance.checkInTime != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPresent ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPresent ? "Present" : "Absent",
        style: TextStyle(
          color: isPresent ? Colors.green[800] : Colors.red[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNoAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "No attendance recorded for today",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildAttendanceLoadingCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
