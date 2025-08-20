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

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

enum LeaveOption { primary, extended, both }

class ApplyLeaveFormScreen extends StatefulWidget {
  const ApplyLeaveFormScreen({super.key});

  @override
  State<ApplyLeaveFormScreen> createState() => _ApplyLeaveFormScreenState();
}

class _ApplyLeaveFormScreenState extends State<ApplyLeaveFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _startPrimaryDateController =
      TextEditingController();
  final TextEditingController _endPrimaryDateController =
      TextEditingController();
  final TextEditingController _startExtendedDateController =
      TextEditingController();
  final TextEditingController _endExtendedDateController =
      TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  LeaveOption? _selectedLeaveOption;
  int? _selectedPrimaryLeaveType;
  int? _selectedExtendedLeaveType;
  int? _selectedSubstituteEmployee;
  String? _selectedHalfDay;

  DateTime? _startDatePrimary, _endDatePrimary;
  DateTime? _startDateExtended, _endDateExtended;

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

  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(LeaveTypeEvent());
    context.read<LeaveBloc>().add(LeaveTypeExtendedEvent());
    context.read<LeaveBloc>().add(SubstitutionEmployeeEvent());
  }

  int _calculateDays(DateTime start, DateTime end) =>
      end.difference(start).inDays + 1;

  String _toNepaliDate(DateTime gregorian) {
    final np = gregorian.toNepaliDateTime();
    return '${np.year}/${np.month.toString().padLeft(2, '0')}/${np.day.toString().padLeft(2, '0')}';
  }

  bool _validateForm() {
    if (_selectedLeaveOption == null) return false;

    // Validate Primary Leave
    if ((_selectedLeaveOption == LeaveOption.primary ||
            _selectedLeaveOption == LeaveOption.both) &&
        (_selectedPrimaryLeaveType == null ||
            _startDatePrimary == null ||
            _endDatePrimary == null)) {
      return false;
    }

    // Validate Extended Leave
    if ((_selectedLeaveOption == LeaveOption.extended ||
            _selectedLeaveOption == LeaveOption.both) &&
        (_selectedExtendedLeaveType == null ||
            _startDateExtended == null ||
            _endDateExtended == null)) {
      return false;
    }

    return true;
  }

  Future<void> _submitForm() async {
    // if (!_formKey.currentState!.validate() || !_validateForm()) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Please fill all required fields")),
    //   );
    //   return;
    // }

    try {
      if (_startPrimaryDateController.text.isNotEmpty) {
        _startDatePrimary = DateTime.parse(_startPrimaryDateController.text);
        _endDatePrimary = DateTime.parse(_endPrimaryDateController.text);
      }
      if (_startExtendedDateController.text.isNotEmpty) {
        _startDateExtended = DateTime.parse(_startExtendedDateController.text);
        _endDateExtended = DateTime.parse(_endExtendedDateController.text);
      }

      final leaveRequest = LeaveApplicationRequestEntity(
        // Primary
        leaveTypeId:
            (_selectedLeaveOption == LeaveOption.primary ||
                _selectedLeaveOption == LeaveOption.both)
            ? _selectedPrimaryLeaveType
            : null,
        fromDate: _startDatePrimary?.toMMDDYYY(),
        toDate: _endDatePrimary?.toMMDDYYY(),
        fromDateNp: _startDatePrimary != null
            ? _toNepaliDate(_startDatePrimary!)
            : null,
        toDateNp: _endDatePrimary != null
            ? _toNepaliDate(_endDatePrimary!)
            : null,
        totalLeaveDays: (_startDatePrimary != null && _endDatePrimary != null)
            ? _calculateDays(_startDatePrimary!, _endDatePrimary!)
            : null,

        // Extended
        extendedLeaveTypeId:
            (_selectedLeaveOption == LeaveOption.extended ||
                _selectedLeaveOption == LeaveOption.both)
            ? _selectedExtendedLeaveType
            : null,
        extendedFromDate: _startDateExtended?.toMMDDYYY(),
        extendedToDate: _endDateExtended?.toMMDDYYY(),
        extendedFromDateNp: _startDateExtended != null
            ? _toNepaliDate(_startDateExtended!)
            : null,
        extendedToDateNp: _endDateExtended != null
            ? _toNepaliDate(_endDateExtended!)
            : null,
        extendedTotalLeaveDays:
            (_startDateExtended != null && _endDateExtended != null)
            ? _calculateDays(_startDateExtended!, _endDateExtended!)
            : null,

        // Common
        reason: _reasonController.text.isNotEmpty
            ? _reasonController.text
            : null,
        substituteEmployeeId: _selectedSubstituteEmployee,
        halfDayStatus: _selectedHalfDay,
        isHalfDay: _selectedHalfDay != null,
      );

      log(
        "Leave Request extended leave days: ${leaveRequest.extendedTotalLeaveDays}",
      );

      context.read<LeaveBloc>().add(
        ApplyLeaveEvent(leaveRequest: leaveRequest),
      );
      _resetForm();
      Navigator.pop(context);
    } catch (e) {
      log("Error while submitting leave form: $e");
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedLeaveOption = null;
      _selectedPrimaryLeaveType = null;
      _selectedExtendedLeaveType = null;
      _selectedSubstituteEmployee = null;
      _selectedHalfDay = null;

      _startPrimaryDateController.clear();
      _endPrimaryDateController.clear();
      _startExtendedDateController.clear();
      _endExtendedDateController.clear();
      _reasonController.clear();

      _startDatePrimary = null;
      _endDatePrimary = null;
      _startDateExtended = null;
      _endDateExtended = null;
    });
  }

  Widget _buildInfoBox() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.blue),
    ),
    child: Row(
      children: [
        Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Your leave request will be reviewed by your supervisor.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade800),
          ),
        ),
      ],
    ),
  );

  Widget _buildPrimaryLeaveSection(List<Map<String, dynamic>> leaveTypes) =>
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Primary Shift Leave",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomDateTimeField(
                      controller: _startPrimaryDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      hintText: "Start Date *",
                      onChanged: (date) {
                        setState(() {
                          _startDatePrimary = DateTime.parse(date);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDateTimeField(
                      controller: _endPrimaryDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      hintText: "End Date *",
                      onChanged: (date) {
                        setState(() {
                          _endDatePrimary = DateTime.parse(date);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomDropdown2(
                value: _selectedPrimaryLeaveType,
                items: leaveTypes,
                hintText: "Select Leave Type *",
                onChanged: (val) => setState(() {
                  _selectedPrimaryLeaveType = val;
                }),
              ),
              const SizedBox(height: 10),
              CustomDropdown(
                value: _selectedHalfDay,
                items: ['On Start', 'On End', 'Both'],
                hintText: 'Half Day',
                onChanged: (val) => setState(() => _selectedHalfDay = val),
              ),
              const SizedBox(height: 10),
              Text("Total Leave Days"),
              const SizedBox(height: 6),
              Text(
                (_startDatePrimary != null && _endDatePrimary != null)
                    ? _calculateDays(
                        _startDatePrimary!,
                        _endDatePrimary!,
                      ).toString()
                    : "0",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

  Widget _buildExtendedLeaveSection(List<Map<String, dynamic>> leaveTypes) =>
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Extended Shift Leave",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomDateTimeField(
                      controller: _startExtendedDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      hintText: "Start Date *",
                      onChanged: (date) {
                        setState(() {
                          _startDateExtended = DateTime.parse(date);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDateTimeField(
                      controller: _endExtendedDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      hintText: "End Date *",
                      onChanged: (date) {
                        setState(() {
                          _endDateExtended = DateTime.parse(date);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomDropdown2(
                value: _selectedExtendedLeaveType,
                items: leaveTypes,
                hintText: "Select Leave Type *",
                onChanged: (val) => setState(() {
                  _selectedExtendedLeaveType = val;
                }),
              ),
              const SizedBox(height: 10),
              Text("Total Leave Days"),
              const SizedBox(height: 6),
              Text(
                (_startDateExtended != null && _endDateExtended != null)
                    ? _calculateDays(
                        _startDateExtended!,
                        _endDateExtended!,
                      ).toString()
                    : "0",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveBloc, LeaveState>(
      listener: (context, state) {
        if (state.status == LeaveStatus.applyLeaveSuccess) {
          AppSnackBar.show(
            context,
            "Leave successfully applied",
            SnackbarType.success,
          );
        } else if (state.status == LeaveStatus.applyLeaveError) {
          AppSnackBar.show(
            context,
            "Leave application failed",
            SnackbarType.error,
          );
        }
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
            .map((e) => {'label': e.text, 'value': int.parse(e.value)})
            .toList();
        final leaveExtendedType = extendedLeaveTypeList
            .map((e) => {'label': e.text, 'value': int.parse(e.value)})
            .toList();
        final substitutionEmployee = substitutionEmployeeList
            .map((e) => {'label': e.text, 'value': int.parse(e.value)})
            .toList();

        return Scaffold(
          appBar: DynamicEMRAppBar(
            title: 'Apply for Leave',
            actions: [
              IconButton(
                onPressed: _resetForm,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoBox(),
                    const SizedBox(height: 16),
                    Text(
                      "Leave Option",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdown(
                      value: _selectedLeaveOption?.name.capitalize(),
                      items: LeaveOption.values
                          .map((e) => e.name.capitalize())
                          .toList(),
                      hintText: 'Select Leave Option *',
                      onChanged: (val) => setState(() {
                        // reset other field on every selection of leave option
                        _selectedPrimaryLeaveType = null;
                        _selectedExtendedLeaveType = null;
                        _selectedSubstituteEmployee = null;
                        _selectedHalfDay = null;

                        _startPrimaryDateController.clear();
                        _endPrimaryDateController.clear();
                        _startExtendedDateController.clear();
                        _endExtendedDateController.clear();
                        _reasonController.clear();

                        _startDatePrimary = null;
                        _endDatePrimary = null;
                        _startDateExtended = null;
                        _endDateExtended = null;
                        _selectedLeaveOption = LeaveOption.values.firstWhere(
                          (e) => e.name.capitalize() == val,
                        );
                      }),
                    ),
                    if (_selectedLeaveOption == LeaveOption.primary ||
                        _selectedLeaveOption == LeaveOption.both)
                      _buildPrimaryLeaveSection(leavePrimaryType),
                    if (_selectedLeaveOption == LeaveOption.extended ||
                        _selectedLeaveOption == LeaveOption.both)
                      _buildExtendedLeaveSection(leaveExtendedType),
                    const SizedBox(height: 16),
                    Text(
                      "Reason",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomInputField(
                      controller: _reasonController,
                      hintText: "Provide a reason",
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Substitute Employee",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomDropdown2(
                      value: _selectedSubstituteEmployee,
                      items: substitutionEmployee,
                      hintText: "Select Substitute",
                      onChanged: (val) => setState(() {
                        _selectedSubstituteEmployee = val;
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send),
                        label: const Text("Submit Leave Request"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
