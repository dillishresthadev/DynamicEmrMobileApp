import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/home/presentation/screens/home_screen.dart';
import 'package:dynamic_emr/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class AppMainNav extends StatefulWidget {
  const AppMainNav({super.key});

  @override
  State<AppMainNav> createState() => _AppMainNavState();
}

class _AppMainNavState extends State<AppMainNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // HomeScreen(),
    // PayrollScreen(),
    // LeavesScreen(),
    // ProfileScreen(),
    HomeScreen(),
    Container(),
    Container(),
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
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: "Payroll",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_outlined),
            activeIcon: Icon(Icons.email),
            label: "Leaves",
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
