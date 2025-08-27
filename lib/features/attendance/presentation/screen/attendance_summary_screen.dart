import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_date_time_field.dart';
import 'package:dynamic_emr/features/attendance/domain/entities/attendence_summary_entity.dart';
import 'package:dynamic_emr/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:dynamic_emr/features/attendance/presentation/widgets/attendance_details_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  final AttendenceSummaryEntity attendenceSummary;
  const AttendanceSummaryScreen({super.key, required this.attendenceSummary});

  @override
  State<AttendanceSummaryScreen> createState() =>
      _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  final TextEditingController _startdatecontroller = TextEditingController();
  final TextEditingController _enddatecontroller = TextEditingController();
  String? _selectedShift;

  final List<String> type = ["Primary", "Extended"];

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
      GetAttendanceSummaryEvent(
        fromDate: DateTime.now().subtract(Duration(days: 7)),
        toDate: DateTime.now(),
        shiftType: "",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _startdatecontroller.dispose();
    _enddatecontroller.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Attendance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Date",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            CustomDateTimeField(
                              prefixIcon: Icon(Icons.date_range),
                              controller: _startdatecontroller,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              hintText: "Start Date",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // End Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End Date",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            CustomDateTimeField(
                              prefixIcon: Icon(Icons.date_range),
                              controller: _enddatecontroller,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              hintText: "End Date",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  CustomDropdown(
                    value: _selectedShift,
                    items: type,
                    hintText: "Type",
                    onChanged: (value) {
                      setState(() {
                        _selectedShift = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_startdatecontroller.text.isEmpty ||
                          _enddatecontroller.text.isEmpty) {
                        return;
                      }
                      context.read<AttendanceBloc>().add(
                        GetAttendanceSummaryEvent(
                          fromDate: DateTime.parse(_startdatecontroller.text),
                          toDate: DateTime.parse(_enddatecontroller.text),
                          shiftType: _selectedShift ?? '',
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text(
                      "Apply Filter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicEMRAppBar(
        title: "Attendance Summary",
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state.status == AttendanceStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == AttendanceStatus.loadSummarySuccess) {
            final attendanceSummary = state.summary;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: attendanceSummary?.attendanceDetails.length,
              itemBuilder: (context, index) {
                final attendanceDetails =
                    attendanceSummary?.attendanceDetails[index];
                if (attendanceSummary!.attendanceDetails.isEmpty) {
                  return Center(child: Text("No Attendence Details"));
                } else {
                  return AttendanceDetailsCardWidget(
                    attendanceDetails: attendanceDetails!,
                  );
                }
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
