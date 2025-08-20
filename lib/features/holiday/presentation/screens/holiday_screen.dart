import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/holiday/presentation/bloc/holiday_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  DateTime? selectedDate;
  List<Map<String, dynamic>> selectedDateHolidays = [];
  List<Map<String, dynamic>> selectedMonthHolidays = [];

  @override
  void initState() {
    super.initState();
    context.read<HolidayBloc>().add(GetAllHolidayList());
    context.read<HolidayBloc>().add(PastHolidayList());
    context.read<HolidayBloc>().add(UpcommingHolidayList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(title: "Holidays"),
      body: BlocBuilder<HolidayBloc, HolidayState>(
        builder: (context, state) {
          if (state.status == HolidayStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HolidayStatus.success) {
            // Extract holiday dates from BLoC state
            final allHolidayDatePairs = state.holidayList
                .expand((h) => h.holidayDates)
                .map(
                  (e) => {
                    'enDate': e.holidayDate,
                    'description': e.description,
                  },
                )
                .toList();

            // Initialize selected date
            selectedDate ??= DateTime.now().toNepaliDateTime();

            // Filter holidays for selected day
            selectedDateHolidays = allHolidayDatePairs.where((holiday) {
              DateTime holidayDate = holiday['enDate'] as DateTime;
              return holidayDate.year == selectedDate!.year &&
                  holidayDate.month == selectedDate!.month &&
                  holidayDate.day == selectedDate!.day;
            }).toList();

            // Filter holidays for current month
            selectedMonthHolidays = allHolidayDatePairs.where((holiday) {
              DateTime holidayDate = holiday['enDate'] as DateTime;
              return holidayDate.year == selectedDate!.year &&
                  holidayDate.month == selectedDate!.month;
            }).toList();

            // List of holiday dates for calendar highlight
            List<DateTime> holidayDates = allHolidayDatePairs
                .map((e) => e['enDate'] as DateTime)
                .toList();

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 16),
                    _buildCalendarCard(holidayDates),
                    const SizedBox(height: 16),
                    if (selectedMonthHolidays.isNotEmpty) ...[
                      Text(
                        "Holidays in ${NepaliDateFormat('MMMM y').format(selectedDate!.toNepaliDateTime())}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedMonthHolidays.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final holiday = selectedMonthHolidays[index];
                            return _buildHolidayCard(holiday, isSmall: true);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildHolidayListSection(),
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Text(
      "Holiday Calendar",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCalendarCard(List<DateTime> holidayDates) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 450,
          child: FlutterBSADCalendar(
            weekColor: Colors.green,
            calendarType: CalendarType.bs,
            primaryColor: AppColors.primary,
            holidays: holidayDates,
            holidayColor: Colors.blueGrey,
            mondayWeek: false,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2040),
            todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withValues(alpha:0.2),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            selectedDayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha:0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            onDateSelected: (date, events) {
              setState(() {
                selectedDate = date.toDateTime();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHolidayListSection() {
    if (selectedDateHolidays.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedDateHolidays
          .map((holiday) => _buildHolidayCard(holiday))
          .toList(),
    );
  }

  Widget _buildHolidayCard(
    Map<String, dynamic> holiday, {
    bool isSmall = false,
  }) {
    final nepaliDate = (holiday['enDate'] as DateTime).toNepaliDateTime();
    return Card(
      color: isSmall ? Colors.grey[200] : Colors.red,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: isSmall
            ? const EdgeInsets.all(8.0)
            : const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSmall)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      holiday['description'] ?? 'Holiday',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      "Holiday",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDateChip(
                  "AD",
                  DateFormat('MMM d, yyyy').format(holiday['enDate']),
                ),
                const SizedBox(width: 8),
                _buildDateChip(
                  "BS",
                  NepaliDateFormat('y MMMM d').format(nepaliDate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(String label, String date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 2),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
