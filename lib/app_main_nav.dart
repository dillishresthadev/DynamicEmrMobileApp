import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/Leave/presentation/screens/leave_screen.dart';
import 'package:dynamic_emr/features/home/presentation/screens/home_screen.dart';
import 'package:dynamic_emr/features/payrolls/presentation/screens/payroll_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/profile_screen.dart';
import 'package:dynamic_emr/features/work/presentation/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppMainNav extends StatefulWidget {
  const AppMainNav({super.key});

  @override
  State<AppMainNav> createState() => _AppMainNavState();
}

class _AppMainNavState extends State<AppMainNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    PayrollScreen(),
    // AttendanceScreen(),
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

  Future<bool> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_selectedIndex != 0) {
          // if not on Home go back to home
          setState(() {
            _selectedIndex = 0;
          });
        } else {
          // if already on home ,show exit dialog
          final shouldExit = await _showExitDialog();
          if (shouldExit && mounted) {
            // exit app
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
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
              icon: Icon(Icons.payment_outlined),
              activeIcon: Icon(Icons.payment),
              label: "Payroll",
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
      ),
    );
  }
}
