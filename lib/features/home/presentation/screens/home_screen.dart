import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/utils/location_utils.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/apply_leave_form_screen.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/screen/attendance_screen.dart';
import 'package:dynamic_emr/features/holiday/presentation/screens/holiday_screen.dart';
import 'package:dynamic_emr/features/home/presentation/screens/shift_screen.dart';
import 'package:dynamic_emr/features/home/presentation/widgets/quick_action_widget.dart';
import 'package:dynamic_emr/features/home/presentation/widgets/today_attendance_widget.dart';
import 'package:dynamic_emr/features/notice/presentation/screens/notice_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:dynamic_emr/features/profile/presentation/widgets/profile_picture_widget.dart';
import 'package:dynamic_emr/features/punch/presentation/bloc/punch_bloc.dart';
import 'package:dynamic_emr/features/work/presentation/screens/create_ticket_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch data
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
    context.read<AttendanceBloc>().add(
      GetAttendanceSummaryEvent(
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        shiftType: "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: DynamicEMRAppBar(title: _getGreeting()),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.employeeStatus == ProfileStatus.error) {
            AppSnackBar.show(
              context,
              "Failed to load employee details",
              SnackbarType.error,
            );
          }
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModernHeader(),
                  TodayAttendanceWidget(),
                  const ShiftScreen(),
                  QuickActionsWidget(
                    actions: [
                      QuickAction(
                        icon: Icons.people,
                        label: 'Attendance',
                        subtitle: 'View attendance',
                        color: const Color(0xFF3BF6BE),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AttendanceScreen(),
                            ),
                          );
                        },
                      ),
                      QuickAction(
                        icon: Icons.event_available,
                        label: 'Leave',
                        subtitle: 'Apply leave',
                        color: const Color(0xFFF6673B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ApplyLeaveFormScreen(),
                            ),
                          );
                        },
                      ),
                      QuickAction(
                        icon: Icons.event_available,
                        label: 'Holidays',
                        subtitle: 'Check calendar',
                        color: const Color(0xFF10B981),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HolidayScreen(),
                            ),
                          );
                        },
                      ),
                      QuickAction(
                        icon: Icons.work_outline,
                        label: 'Ticket',
                        subtitle: 'Create new ticket',
                        color: const Color(0xFFF59E0B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateTicketFormScreen(),
                            ),
                          );
                        },
                      ),
                      QuickAction(
                        icon: Icons.fingerprint,
                        label: 'Punch In',
                        subtitle: 'Check In / Out',
                        color: const Color(0xFF10B943),
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text("Confirm Action"),
                              content: const Text(
                                "Are you sure you want to punch in/out?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final location = await LocationUtils.getLatLng(
                              context,
                            );
                            if (location != null) {
                              context.read<PunchBloc>().add(
                                TodayPunchEvent(
                                  long: location["longitude"].toString(),
                                  lat: location["latitude"].toString(),
                                ),
                              );
                              AppSnackBar.show(
                                context,
                                "Punched In success",
                                SnackbarType.success,
                              );
                            } else {
                              AppSnackBar.show(
                                context,
                                "Could not get location.",
                                SnackbarType.error,
                              );
                            }
                          }
                        },
                      ),
                      QuickAction(
                        icon: Icons.history,
                        label: 'Punch History',
                        subtitle: 'View punch history',
                        color: const Color(0xFF1067B9),
                        onTap: () {
                          context.read<PunchBloc>().add(
                            GetTodayPunchListEvent(),
                          );
                          _showPunchHistory(context);
                        },
                      ),
                    ],
                  ),

                  // _buildQuickStatsSection(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
    context.read<AttendanceBloc>().add(
      GetAttendanceSummaryEvent(
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
        shiftType: "",
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Row(
            children: [
              ProfilePictureWidget(
                profileUrl:
                    "${state.employee?.employeeImageBaseUrl}/${state.employee?.imagePath}",
                firstName: state.employee?.firstName ?? 'Dynamic',
                lastName: state.employee?.lastName ?? 'EMR',
                avatarRadius: 20,
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildUserInfo(state)),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoticeScreen()),
                  );
                },
                icon: Icon(Icons.notifications_outlined, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(ProfileState state) {
    String name = 'Dynamic EMR';
    String position = '';

    if (state.employeeStatus == ProfileStatus.loaded) {
      name = state.employee?.employeeFullName ?? '';
      position = state.employee?.designationTitle ?? '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          position,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showPunchHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final screenHeight = MediaQuery.sizeOf(context).height;

        return SizedBox(
          height: screenHeight * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Today's Punch History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<PunchBloc, PunchState>(
                    builder: (context, state) {
                      if (state.status == PunchStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == PunchStatus.error) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state.punchList.isEmpty) {
                        return const Center(
                          child: Text(
                            "No punch history for today",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: state.punchList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final punch = state.punchList[index];
                          final punchTime = DateTime.parse(
                            punch.punchTime.toString(),
                          ).toLocal();

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.fingerprint,
                                      color: Colors.blue,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${punchTime.hour.toString().padLeft(2, '0')}:${punchTime.minute.toString().padLeft(2, '0')} - ${punchTime.day.toString().padLeft(2, '0')}/${punchTime.month.toString().padLeft(2, '0')}/${punchTime.year}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          punch.systemDtl,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      punch.logType ?? "Manual",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1F2937), Colors.grey[800]!],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Hours Worked', '38.5h', Icons.timer),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Days Present',
                    '4/5',
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildStatItem('On Time', '80%', Icons.schedule),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
