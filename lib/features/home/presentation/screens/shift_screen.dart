import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_current_shift_entity.dart';
import 'package:dynamic_emr/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(GetEmployeeDetailsEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.employeeStatus == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.employeeStatus == ProfileStatus.loaded) {
          final shiftList = _mapShiftData(
            state.employee?.employeeCurrentShift ??
                EmployeeCurrentShiftEntity(),
          );
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: shiftList.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, i) => ModernShiftCard(data: shiftList[i]),
                ),
              ),
              if (shiftList.length > 1)
                _PageIndicator(
                  length: shiftList.length,
                  currentIndex: _currentIndex,
                  controller: _pageController,
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<ShiftData> _mapShiftData(EmployeeCurrentShiftEntity e) {
    final shifts = <ShiftData>[
      ShiftData(
        title: e.primaryShiftName ?? 'Primary Shift',
        start: e.primaryShiftStart ?? '',
        end: e.primaryShiftEnd ?? '',
        date: e.currentDateNp ?? '',
      ),
    ];

    if (e.hasBreak == true) {
      shifts.add(
        ShiftData(
          title: "Break",
          start: e.breakStartTime ?? '',
          end: e.breakEndTime ?? '',
          date: e.currentDateNp ?? '',
        ),
      );
    }

    if (e.hasMultiShift == true) {
      shifts.add(
        ShiftData(
          title: "Extended Shift",
          start: e.extendedShiftStart ?? '',
          end: e.extendedShiftEnd ?? '',
          date: e.currentDateNp ?? '',
        ),
      );
    }
    return shifts;
  }
}

/// --- DATA HOLDER ---
class ShiftData {
  final String title, start, end, date;
  ShiftData({
    required this.title,
    required this.start,
    required this.end,
    required this.date,
  });
}

/// --- SHIFT CARD ---
class ModernShiftCard extends StatelessWidget {
  final ShiftData data;
  const ModernShiftCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final start = DateTime.tryParse(data.start);
    final end = DateTime.tryParse(data.end);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // subtle black shadow
            offset: const Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // HRMS accent blue glow
            offset: const Offset(-2, -2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(date: data.date, title: data.title),
          const Spacer(),
          _TimeRow(start: start, end: end),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String date, title;
  const _Header({required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Icon(_getIcon(title), color: Colors.white, size: 28),
      ],
    );
  }

  IconData _getIcon(String title) {
    if (title.toLowerCase().contains("break")) return Icons.coffee;
    if (title.toLowerCase().contains("extended")) return Icons.access_time;
    return Icons.work_outline;
  }
}

class _TimeRow extends StatelessWidget {
  final DateTime? start, end;
  const _TimeRow({this.start, this.end});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _timeColumn(
              "Start",
              start ?? DateTime.now(),
              Icons.play_circle_outline,
            ),
          ),
          Container(width: 2, height: 36, color: Colors.white24),
          Expanded(
            child: _timeColumn(
              "End",
              end ?? DateTime.now(),
              Icons.stop_circle_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeColumn(String label, DateTime t, IconData icon) => Column(
    children: [
      Icon(icon, size: 20, color: Colors.white70),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}

/// --- PAGE INDICATOR ---
class _PageIndicator extends StatelessWidget {
  final int length, currentIndex;
  final PageController controller;
  const _PageIndicator({
    required this.length,
    required this.currentIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isActive = i == currentIndex;
        return GestureDetector(
          onTap: () => controller.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? 22 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? Colors.white
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }
}
