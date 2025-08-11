import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/widgets/attendance_card_widget.dart';
import 'package:dynamic_emr/features/attendance/presentation/widgets/attendance_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  const AttendanceSummaryScreen({super.key});

  @override
  State<AttendanceSummaryScreen> createState() =>
      _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(GetCurrentMonthAttendancePrimaryEvent());
    context.read<AttendanceBloc>().add(
      GetCurrentMonthAttendanceExtendedEvent(),
    );
    // setting fromDate and toDate to cover the current month by default when creating the GetAttendanceSummaryEvent
    // final now = DateTime.now();
    // final firstDayOfMonth = DateTime(now.year, now.month, 1);
    // final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    // context.read<AttendanceBloc>().add(
    //   GetAttendanceSummaryEvent(
    //     fromDate: firstDayOfMonth,
    //     toDate: lastDayOfMonth,
    //     shiftType: "Primary",
    //   ),
    // );
    // setting fromDate and toDate to cover the This week by default when creating the GetAttendanceSummaryEvent

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(
      const Duration(days: 6),
    ); // last 7 days including today

    context.read<AttendanceBloc>().add(
      GetAttendanceSummaryEvent(
        fromDate: oneWeekAgo,
        toDate: now,
        shiftType: "Primary",
      ),
    );
  }

  final statusCards = [
    {
      'title': 'Working Days',
      'icon': Icons.work_outline,
      'color': const Color(0xFF2563EB),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'title': 'Present',
      'icon': Icons.check_circle_outline,
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFECFDF5),
    },
    {
      'title': 'Leave',
      'icon': Icons.cancel_outlined,
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEF2F2),
    },
    {
      'title': 'Week End',
      'icon': Icons.timelapse,
      'color': Colors.orange,
      'bgColor': const Color(0xFFFFF7E6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(title: "Attendance Summary"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceErrorState) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            } else if (state is AttendanceCompleteState) {
              final primary = state.primary;
              final extended = state.extended;
              final attendanceSummary = state.attendanceSummary;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary Attendance Section
                    const SizedBox(height: 16),
                    const Text(
                      'Primary Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.8,
                          ),
                      itemCount: primary.length,
                      itemBuilder: (context, index) {
                        final primaryAttendance = primary[index];
                        final stat = statusCards.firstWhere(
                          (e) => e['title'] == primaryAttendance.category,
                          orElse: () => {
                            'title': primaryAttendance.category,
                            'icon': Icons.help_outline,
                            'color': Colors.grey,
                            'bgColor': Colors.grey.shade200,
                          },
                        );

                        return AttendanceCardWidget(
                          icon: stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          bgColor: stat['bgColor'] as Color,
                          count: primaryAttendance.qty.toString(),
                          label: primaryAttendance.category,
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                    // Extended Attendance Section
                    const Text(
                      'Extended Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.8,
                          ),
                      itemCount: extended.length,
                      itemBuilder: (context, index) {
                        final extendedAttendance = extended[index];
                        final stat = statusCards.firstWhere(
                          (e) => e['title'] == extendedAttendance.category,
                          orElse: () => {
                            'title': extendedAttendance.category,
                            'icon': Icons.help_outline,
                            'color': Colors.grey,
                            'bgColor': Colors.grey.shade200,
                          },
                        );

                        return AttendanceCardWidget(
                          icon: stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          bgColor: stat['bgColor'] as Color,
                          count: extendedAttendance.qty.toString(),
                          label: extendedAttendance.category,
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Attendance Summary Section
                    if (attendanceSummary != null) ...[
                      const Text(
                        'Recent Attendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attendanceSummary.attendanceDetails.length,
                        itemBuilder: (context, index) {
                          final attendanceDetails =
                              attendanceSummary.attendanceDetails[index];
                          return AttendanceDetailsCardWidget(
                            attendanceDetails: attendanceDetails,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
