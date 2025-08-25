import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayAttendanceWidget extends StatefulWidget {
  const TodayAttendanceWidget({super.key});

  @override
  State<TodayAttendanceWidget> createState() => _TodayAttendanceWidgetState();
}

class _TodayAttendanceWidgetState extends State<TodayAttendanceWidget> {
  String formatTime(DateTime? time) =>
      time != null ? DateFormat('hh:mm a').format(time) : '-';
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
            color: Colors.grey.withValues(alpha: 0.1),
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
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
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
              (todayAttendance.checkInTime == null &&
                      todayAttendance.checkOutTime == null)
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            todayAttendance.statusColorCode.startsWith("#") &&
                                todayAttendance.statusColorCode.length == 7
                            ? Color(
                                int.parse(
                                  todayAttendance.statusColorCode.replaceFirst(
                                    "#",
                                    "0xFF",
                                  ),
                                ),
                              )
                            : null,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        todayAttendance.statusFullName.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          (todayAttendance.checkInTime != null &&
                  todayAttendance.checkOutTime != null)
              ? Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 5,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatTime(todayAttendance.checkInTime),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        spacing: 5,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatTime(todayAttendance.checkOutTime),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(height: 10),
          (todayAttendance.checkInTime != null &&
                  todayAttendance.checkOutTime != null)
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          todayAttendance.statusColorCode.startsWith("#") &&
                              todayAttendance.statusColorCode.length == 7
                          ? Color(
                              int.parse(
                                todayAttendance.statusColorCode.replaceFirst(
                                  "#",
                                  "0xFF",
                                ),
                              ),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      todayAttendance.statusFullName.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  // Widget _buildStatusBadge(todayAttendance) {
  //   final isPresent = todayAttendance.checkInTime != null;
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: isPresent ? Colors.green[100] : Colors.red[100],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       isPresent ? "Present" : "Absent",
  //       style: TextStyle(
  //         color: isPresent ? Colors.green[800] : Colors.red[800],
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNoAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
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
