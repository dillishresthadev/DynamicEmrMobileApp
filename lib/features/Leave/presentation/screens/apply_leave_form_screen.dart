import 'dart:developer';

import 'package:dynamic_emr/core/constants/app_colors.dart';
import 'package:dynamic_emr/core/extension/date_extension.dart';
import 'package:dynamic_emr/core/utils/app_snack_bar.dart';
import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_date_time_field.dart';
import 'package:dynamic_emr/core/widgets/form/custom_input_field.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_request_entity.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_type_entity.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';

class ApplyLeaveFormScreen extends StatefulWidget {
  const ApplyLeaveFormScreen({super.key});

  @override
  State<ApplyLeaveFormScreen> createState() => _ApplyLeaveFormScreenState();
}

class _ApplyLeaveFormScreenState extends State<ApplyLeaveFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startPrimaryDateController =
      TextEditingController();
  final TextEditingController _endPrimaryDateController =
      TextEditingController();
  final TextEditingController _startExtendedDateController =
      TextEditingController();
  final TextEditingController _endExtendedDateController =
      TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  int? _selectedPrimaryLeaveType;
  int? _selectedExtendedLeaveType;
  int? _selectedSubstituteEmployee;
  String? _selectedhalfday;

  DateTime? _startDatePrimary;
  DateTime? _endDatePrimary;
  DateTime? _startDateExtended;
  DateTime? _endDateExtended;

  List<LeaveTypeEntity> primaryLeaveTypeList = [];
  List<LeaveTypeEntity> extendedLeaveTypeList = [];
  List<LeaveTypeEntity> substitutionEmployeeList = [];

  @override
  void dispose() {
    _startPrimaryDateController.dispose();
    _endPrimaryDateController.dispose();
    _startExtendedDateController.dispose();
    _endExtendedDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  int calculateTotalLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  String convertToNepaliDate(DateTime gregorianDate) {
    final nepaliDate = gregorianDate.toNepaliDateTime();
    return '${nepaliDate.year}-${nepaliDate.month.toString().padLeft(2, '0')}-${nepaliDate.day.toString().padLeft(2, '0')}';
  }

  bool _validateForm() {
    // Validate primary leave fields
    if (_selectedPrimaryLeaveType == null ||
        _startDatePrimary == null ||
        _endDatePrimary == null) {
      return false;
    }

    // Validate extended leave fields (if any are filled)
    if (_startDateExtended != null ||
        _endDateExtended != null ||
        _selectedExtendedLeaveType != null) {
      if (_startDateExtended == null ||
          _endDateExtended == null ||
          _selectedExtendedLeaveType == null) {
        return false;
      }
    }

    return true;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      if (!_validateForm()) {
        AppSnackBar.show(
          context,
          "Please fill all required fields correctly",
          SnackbarType.error,
        );
        return;
      }
    }

    try {
      _startDatePrimary = DateTime.parse(_startPrimaryDateController.text);
      _endDatePrimary = DateTime.parse(_endPrimaryDateController.text);
      _startDateExtended = DateTime.parse(_startExtendedDateController.text);
      _endDateExtended = DateTime.parse(_endExtendedDateController.text);
      final fromDateNp = convertToNepaliDate(
        _startDatePrimary!,
      ).replaceAll('-', '/');
      final toDateNp = convertToNepaliDate(
        _endDatePrimary!,
      ).replaceAll('-', '/');
      final leaveRequest = LeaveApplicationRequestEntity(
        leaveTypeId: _selectedPrimaryLeaveType,
        fromDate: _startDatePrimary?.toMMDDYYY(),
        toDate: _endDatePrimary?.toMMDDYYY(),
        fromDateNp: fromDateNp,
        toDateNp: toDateNp,
        totalLeaveDays: calculateTotalLeaveDays(
          _startDatePrimary!,
          _endDatePrimary!,
        ),
        reason: _reasonController.text.isNotEmpty
            ? _reasonController.text
            : null,
        substituteEmployeeId: _selectedSubstituteEmployee!,
        extendedLeaveTypeId: _selectedExtendedLeaveType,
        extendedFromDate: _startDateExtended?.toMMDDYYY(),
        extendedToDate: _endDateExtended?.toMMDDYYY(),
        extendedFromDateNp: _startDateExtended != null
            ? convertToNepaliDate(_startDateExtended!).replaceAll('-', '/')
            : null,
        extendedToDateNp: _endDateExtended != null
            ? convertToNepaliDate(_endDateExtended!).replaceAll('-', '/')
            : null,
        halfDayStatus: _selectedhalfday,
        isHalfDay: _selectedhalfday == 'Both' || _selectedhalfday == 'On Start',
      );
      context.read<LeaveBloc>().add(
        ApplyLeaveEvent(leaveRequest: leaveRequest),
      );

      _resetForm();
    } catch (e) {
      log("Error while submitting leave form : $e");
    } finally {
      Navigator.pop(context);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _endExtendedDateController.clear();
      _startExtendedDateController.clear();
      _endPrimaryDateController.clear();
      _startPrimaryDateController.clear();
      _reasonController.clear();
      _selectedPrimaryLeaveType = null;
      _selectedExtendedLeaveType = null;
      _selectedSubstituteEmployee = null;
      _selectedhalfday = null;
      _startDatePrimary = null;
      _endDatePrimary = null;
      _startDateExtended = null;
      _endDateExtended = null;
    });
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
    return BlocConsumer<LeaveBloc, LeaveState>(
      listener: (context, state) {
        if (state.status == LeaveStatus.leaveTypeSuccess) {
          primaryLeaveTypeList = state.leaveType;
        }
        if (state.status == LeaveStatus.extendedLeaveTypeSuccess) {
          extendedLeaveTypeList = state.extendedLeaveType;
        }
        if (state.status == LeaveStatus.substitutionEmployeeSuccess) {
          substitutionEmployeeList = state.substitutionEmployee;
        }
      },
      builder: (context, state) {
        final leavePrimaryType = primaryLeaveTypeList
            .map(
              (primaryType) => {
                'label': primaryType.text,
                'value': int.parse(primaryType.value),
              },
            )
            .toList();
        final leaveExtendedType = extendedLeaveTypeList
            .map(
              (extendedType) => {
                'label': extendedType.text,
                'value': int.parse(extendedType.value),
              },
            )
            .toList();
        final substitutionEmployee = substitutionEmployeeList
            .map(
              (substitude) => {
                'label': substitude.text,
                'value': int.parse(substitude.value),
              },
            )
            .toList();
        return Scaffold(
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

                          Text(
                            "Primary Shift Leave",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // primary shift Date Selection Section
                          Row(
                            children: [
                              Expanded(
                                child: CustomDateTimeField(
                                  controller: _startPrimaryDateController,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  hintText: "Start Date *",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDateTimeField(
                                  controller: _endPrimaryDateController,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  hintText: "End Date *",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          Text(
                            "Leave Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Leave Primary Type Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdown2(
                                value: _selectedPrimaryLeaveType,
                                items: leavePrimaryType,
                                hintText: "Select Leave Type *",
                                validator: (value) => value == null
                                    ? 'Leave type is required'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPrimaryLeaveType = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          Text(
                            "Half Day",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          CustomDropdown(
                            value: _selectedhalfday,
                            items: ['On Start', 'On End', 'Both'],
                            hintText: 'Select an option',
                            onChanged: (value) {
                              setState(() {
                                _selectedhalfday = value;
                              });
                            },
                          ),

                          SizedBox(height: 10),
                          Text(
                            "Extended Shift Leave",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDateTimeField(
                                  controller: _startExtendedDateController,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  hintText: "Start Date *",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDateTimeField(
                                  controller: _endExtendedDateController,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  hintText: "End Date *",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "Leave Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Leave Extended Type Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdown2(
                                value: _selectedExtendedLeaveType,
                                items: leaveExtendedType,
                                hintText: "Select Leave Type *",
                                validator: (value) => value == null
                                    ? 'Leave type is required'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedExtendedLeaveType = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

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
                                    "Please provide a reason for your leave",
                                maxLines: 2,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "Substitute Employee",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          // Substitute Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdown2(
                                value: _selectedSubstituteEmployee,
                                items: substitutionEmployee,
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

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.send),
                              label: Text(
                                'Submit Leave Request',
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
        );
      },
    );
  }
}
