import 'dart:developer';

import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/extension/date_extension.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_date_time_field.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyLeaveFormScreen extends StatefulWidget {
  const ApplyLeaveFormScreen({super.key});

  @override
  State<ApplyLeaveFormScreen> createState() => _ApplyLeaveFormScreenState();
}

class _ApplyLeaveFormScreenState extends State<ApplyLeaveFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? _selectedShiftType;
  String? _selectedLeaveType;
  String? _selectedSubstituteEmployee;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  final List<String> _shiftType = ["Primary", "Extended"];

  List<LeaveTypeEntity> leaveTypeList = [];
  List<LeaveTypeEntity> extendedLeaveTypeList = [];
  List<LeaveTypeEntity> substitutionEmployeeList = [];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  int calculateTotalLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      log("Please fill all required fields correctly");
      return;
    }

    if (_selectedLeaveType == null) {
      log("Please select a leave type");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _startDate = DateTime.parse(_startDateController.text);
      _endDate = DateTime.parse(_endDateController.text);
      final leaveRequest = LeaveApplicationRequestEntity(
        leaveTypeId: 2,
        fromDate: _startDate!.toMMDDYYY(),
        toDate: _endDate!.toMMDDYYY(),
        // fromDateNp: fromDateNp,
        // toDateNp: toDateNp,
        totalLeaveDays: calculateTotalLeaveDays(_startDate!, _endDate!),
        // reason: _reasonController.text.isNotEmpty
        //     ? _reasonController.text
        //     : null,
        // substituteEmployeeId: _selectedSubstitudeEmployee!,
        // extendedLeaveTypeId: _selectedExtendedleaveType,
        // extendedFromDate: _extendedStartDate != null
        //     ? _extendedStartDate.toMMDDYYY()
        //     : null,
        // extendedToDate: _extendedEndDate != null
        //     ? _extendedEndDate.toMMDDYYY()
        //     : null,
        // extendedFromDateNp: _extendedDate != null
        //     ? convertToNepaliDate(_extendedDate!).replaceAll('-', '/')
        //     : null,
        // extendedToDateNp: _extendedEndDate != null
        //     ? convertToNepaliDate(_extendedEndDate!).replaceAll('-', '/')
        //     : null,
        // halfDayStatus: _selectedhalfday,
        // isHalfDay: _selectedhalfday == 'Both' || _selectedhalfday == 'On Start',
      );
      context.read<LeaveBloc>().add(
        ApplyLeaveEvent(leaveRequest: leaveRequest),
      );
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      log('Leave Request: $leaveRequest');

      _resetForm();
    } catch (e) {
      log("Error : $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedLeaveType = null;
      _selectedSubstituteEmployee = null;
      _startDate = null;
      _endDate = null;
    });
    _startDateController.clear();
    _endDateController.clear();
    _reasonController.clear();
  }

  @override
  void initState() {
    super.initState();
    // Trigger events to load the lists if needed
    context.read<LeaveBloc>().add(LeaveTypeEvent());
    context.read<LeaveBloc>().add(LeaveTypeExtendedEvent());
    context.read<LeaveBloc>().add(SubstitutionEmployeeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveBloc, LeaveState>(
      listener: (context, state) {
        if (state.status == LeaveStatus.leaveTypeSuccess) {
          leaveTypeList = state.leaveType;
        }
        if (state.status == LeaveStatus.extendedLeaveTypeSuccess) {
          extendedLeaveTypeList = state.extendedLeaveType;
        }
        if (state.status == LeaveStatus.substitutionEmployeeSuccess) {
          substitutionEmployeeList = state.substitutionEmployee;
        }
      },
      child: Scaffold(
        appBar: DynamicEMRAppBar(
          title: 'Apply for Leave',
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Form',
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your leave request will be reviewed by your supervisor. You will receive a notification once it has been approved or rejected.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.blue.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        // Date Selection Section
                        Text(
                          "Shift Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              value: _selectedShiftType,
                              items: _shiftType,
                              hintText: "Select Shift Type *",
                              onChanged: (value) {
                                setState(() {
                                  _selectedShiftType = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),

                            Text(
                              "Date FROM - TO",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDateTimeField(
                                    controller: _startDateController,
                                    hintText: "Start Date *",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomDateTimeField(
                                    controller: _endDateController,
                                    hintText: "End Date *",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Text(
                          "Leave Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Leave Type Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              value: _selectedLeaveType,
                              items: _selectedShiftType == "Primary"
                                  ? leaveTypeList.map((e) => e.text).toList()
                                  : extendedLeaveTypeList
                                        .map((e) => e.text)
                                        .toList(),
                              hintText: "Select Leave Type *",
                              onChanged: (value) {
                                setState(() {
                                  _selectedLeaveType = value;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Substitute Employee",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Substitute Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              value: _selectedSubstituteEmployee,
                              items: substitutionEmployeeList
                                  .map((e) => e.text)
                                  .toList(),
                              hintText: "Select Substitute Employee",
                              onChanged: (value) {
                                setState(() {
                                  _selectedSubstituteEmployee = value;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Select a colleague who can cover your responsibilities during your absence',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Reason Section
                        Text(
                          "Leave Reason",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomInputField(
                              controller: _reasonController,
                              hintText:
                                  "Please provide a reason for your leave *",
                              maxLines: 2,

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Reason is required';
                                }
                                if (value.trim().length < 10) {
                                  return 'Please provide a more detailed reason (at least 10 characters)';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(
                              _isLoading
                                  ? 'Submitting...'
                                  : 'Submit Leave Request',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
