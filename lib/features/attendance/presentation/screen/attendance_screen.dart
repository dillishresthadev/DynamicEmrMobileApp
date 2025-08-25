import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/screen/attendance_summary_screen.dart';
import 'package:dynamic_emr/features/attendance/presentation/widgets/attendance_card_widget.dart';
import 'package:dynamic_emr/features/attendance/presentation/widgets/attendance_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(GetCurrentMonthAttendancePrimaryEvent());
    context.read<AttendanceBloc>().add(
      GetCurrentMonthAttendanceExtendedEvent(),
    );

    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 6));
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
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(
        title: "Attendance",
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            // If no data has loaded yet
            if (state.primary == null &&
                state.extended == null &&
                state.summary == null &&
                state.status == AttendanceStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Primary Attendance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (state.status == AttendanceStatus.loading &&
                      state.primary == null)
                    const Center(child: CircularProgressIndicator())
                  else GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.3,
                        ),
                    itemCount: state.primary!.length,
                    itemBuilder: (context, index) {
                      final primaryAttendance = state.primary![index];
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
                  const Text(
                    'Extended Attendance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (state.status == AttendanceStatus.loading &&
                      state.extended == null)
                    const Center(child: CircularProgressIndicator())
                  else GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.3,
                        ),
                    itemCount: state.extended!.length,
                    itemBuilder: (context, index) {
                      final extendedAttendance = state.extended![index];
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

                  if (state.summary != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceSummaryScreen(
                                  attendenceSummary: state.summary!,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.summary!.attendanceDetails.length,
                      itemBuilder: (context, index) {
                        final attendanceDetails =
                            state.summary!.attendanceDetails[index];
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
          },
        ),
      ),
    );
  }
}
