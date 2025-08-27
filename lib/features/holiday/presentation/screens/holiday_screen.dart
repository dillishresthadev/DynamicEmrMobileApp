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
  bool showNepaliDate = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    context.read<HolidayBloc>().add(UpcommingHolidayList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Holidays",
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(
              showNepaliDate ? Icons.calendar_today : Icons.calendar_month,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showNepaliDate = !showNepaliDate;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<HolidayBloc, HolidayState>(
        builder: (context, state) {
          if (state.status == HolidayStatus.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading holidays...'),
                ],
              ),
            );
          } else if (state.status == HolidayStatus.success) {
            final allHolidayDatePairs = state.holidayList
                .expand((h) => h.holidayDates)
                .map(
                  (e) => {
                    'enDate': e.holidayDate,
                    'description': e.description,
                  },
                )
                .toList();

            // Remove duplicates (only keep first holiday per date)
            final uniqueHolidayMap = <String, Map<String, dynamic>>{};
            for (var holiday in allHolidayDatePairs) {
              final dateKey = DateFormat(
                'yyyy-MM-dd',
              ).format(holiday['enDate'] as DateTime);
              if (!uniqueHolidayMap.containsKey(dateKey)) {
                uniqueHolidayMap[dateKey] = holiday;
              }
            }
            final uniqueHolidayList = uniqueHolidayMap.values.toList();

            selectedDate ??= DateTime.now();

            // Filter holidays for selected day
            selectedDateHolidays = uniqueHolidayList.where((holiday) {
              DateTime holidayDate = holiday['enDate'] as DateTime;
              return holidayDate.year == selectedDate!.year &&
                  holidayDate.month == selectedDate!.month &&
                  holidayDate.day == selectedDate!.day;
            }).toList();

            // Filter holidays for current month
            selectedMonthHolidays = uniqueHolidayList.where((holiday) {
              DateTime holidayDate = holiday['enDate'] as DateTime;
              return holidayDate.year == selectedDate!.year &&
                  holidayDate.month == selectedDate!.month;
            }).toList();

            // List of holiday dates for calendar highlight
            List<DateTime> holidayDates = uniqueHolidayList
                .map((e) => e['enDate'] as DateTime)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCalendarCard(holidayDates),
                        const SizedBox(height: 20),
                        if (selectedDateHolidays.isNotEmpty) ...[
                          _buildSelectedDateSection(),
                          const SizedBox(height: 20),
                        ],
                        if (selectedMonthHolidays.isNotEmpty) ...[
                          _buildMonthlyHolidaysSection(),
                          const SizedBox(height: 20),
                        ],
                        _buildUpcomingHolidaysSection(uniqueHolidayList),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCalendarCard(List<DateTime> holidayDates) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showNepaliDate
                      ? "नेपाली पात्रो (BS)"
                      : "English Calendar (AD)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    showNepaliDate ? "BS" : "AD",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 415,
              child: FlutterBSADCalendar(
                weekColor: Colors.grey[600]!,
                calendarType: showNepaliDate
                    ? CalendarType.bs
                    : CalendarType.ad,
                primaryColor: AppColors.primary,
                holidays: holidayDates,
                holidayColor: Colors.red[400]!,
                mondayWeek: false,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2015),
                lastDate: DateTime(2040),
                todayDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                selectedDayDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected Date Holidays",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        ...selectedDateHolidays.map(
          (holiday) => _buildHolidayCard(holiday, isSelected: true),
        ),
      ],
    );
  }

  Widget _buildMonthlyHolidaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Holidays in ${showNepaliDate ? NepaliDateFormat('MMMM y').format(selectedDate!.toNepaliDateTime()) : DateFormat('MMMM yyyy').format(selectedDate!)}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedMonthHolidays.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final holiday = selectedMonthHolidays[index];
              return _buildCompactHolidayCard(holiday);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingHolidaysSection(List<Map<String, dynamic>> allHolidays) {
    final upcomingHolidays = allHolidays
        .where(
          (holiday) => (holiday['enDate'] as DateTime).isAfter(DateTime.now()),
        )
        .take(3)
        .toList();

    if (upcomingHolidays.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming Holidays",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        ...upcomingHolidays.map((holiday) => _buildHolidayCard(holiday)),
      ],
    );
  }

  Widget _buildHolidayCard(
    Map<String, dynamic> holiday, {
    bool isSelected = false,
  }) {
    final nepaliDate = (holiday['enDate'] as DateTime).toNepaliDateTime();
    final isToday = DateUtils.isSameDay(holiday['enDate'], DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 6 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isSelected ? Colors.red[50] : Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.red[200]! : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        holiday['description'] ?? 'Holiday',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.red[700]
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateChip(
                        "AD",
                        DateFormat('MMM d, yyyy').format(holiday['enDate']),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateChip(
                        "BS",
                        NepaliDateFormat('y MMMM d').format(nepaliDate),
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHolidayCard(Map<String, dynamic> holiday) {
    final nepaliDate = (holiday['enDate'] as DateTime).toNepaliDateTime();

    return SizedBox(
      width: 200,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                holiday['description'] ?? 'Holiday',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _buildDateChip(
                      "AD",
                      DateFormat('MMM d').format(holiday['enDate']),
                      Colors.blue,
                      isCompact: true,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildDateChip(
                      "BS",
                      NepaliDateFormat('MMM d').format(nepaliDate),
                      Colors.green,
                      isCompact: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(
    String label,
    String date,
    Color color, {
    bool isCompact = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 12,
        vertical: isCompact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: TextStyle(
              fontSize: isCompact ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
