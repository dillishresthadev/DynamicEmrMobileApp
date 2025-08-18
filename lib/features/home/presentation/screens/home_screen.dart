import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/screen/attendance_screen.dart';
import 'package:dynamic_emr/features/holiday/presentation/screens/holiday_screen.dart';
import 'package:dynamic_emr/features/home/presentation/screens/shift_screen.dart';
import 'package:dynamic_emr/features/home/presentation/widgets/quick_action_widget.dart';
import 'package:dynamic_emr/features/home/presentation/widgets/today_attendance_widget.dart';
import 'package:dynamic_emr/features/notice/presentation/screens/notice_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
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
          if (state is ProfileErrorState) {
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
                        icon: Icons.new_releases_outlined,
                        label: 'Notices',
                        subtitle: 'View announcements',
                        color: const Color(0xFF3B82F6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NoticeScreen(),
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
                    ],
                  ),

                  _buildQuickStatsSection(),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20,20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [AppColors.primary, Color(0xFF5C92F6)],
        // ),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Row(
            children: [
              _buildProfileAvatar(state),
              const SizedBox(width: 16),
              Expanded(child: _buildUserInfo(state)),
              // _buildNotificationButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileState state) {
    String initials = 'D';
    if (state is ProfileLoadedState) {
      final nameParts = state.employee.firstName.split(' ');
      if (nameParts.isNotEmpty) {
        initials = nameParts.length > 1
            ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
            : nameParts.first[0].toUpperCase();
      }
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(ProfileState state) {
    String name = 'Dynamic EMR';
    String position = '';

    if (state is ProfileLoadedState) {
      name = state.employee.employeeFullName;
      position = state.employee.designationTitle;
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
