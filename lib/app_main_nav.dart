import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/leave_screen.dart';
import 'package:dynamic_emr/features/attendance/presentation/screen/attendance_screen.dart';
import 'package:dynamic_emr/features/home/presentation/screens/home_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/profile_screen.dart';
import 'package:dynamic_emr/features/work/presentation/screens/work_screen.dart';
import 'package:flutter/material.dart';

class AppMainNav extends StatefulWidget {
  const AppMainNav({super.key});

  @override
  State<AppMainNav> createState() => _AppMainNavState();
}

class _AppMainNavState extends State<AppMainNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AttendanceScreen(),
    LeaveScreen(),
    WorkScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primary.withValues(alpha: 0.8),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            activeIcon: Icon(Icons.access_time_filled),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            activeIcon: Icon(Icons.date_range),
            label: "Leaves",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: "Work",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
