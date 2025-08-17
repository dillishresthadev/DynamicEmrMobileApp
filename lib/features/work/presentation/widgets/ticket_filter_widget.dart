import 'package:dynamic_emr/core/widgets/dropdown/custom_dropdown.dart';
import 'package:dynamic_emr/core/widgets/form/custom_date_time_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketFilterWidget extends StatefulWidget {
  final void Function(TicketFilterData)? onApply;

  final void Function()? onClear;

  const TicketFilterWidget({this.onApply, this.onClear, super.key});

  @override
  State<TicketFilterWidget> createState() => _TicketFilterWidgetState();
}

class _TicketFilterWidgetState extends State<TicketFilterWidget> {
  // Filter Controllers
  int _selectedCategory = 0;
  String? _selectedStatus = "Open";
  String? _selectedPriority;
  String? _selectedSeverity;
  String? _selectedOrderBy = "Newest";

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  final List<String> statuses = ['Open', 'Closed'];
  final List<String> priorities = ['Low', 'Medium', 'High'];
  final List<String> severities = ['Low', 'Medium', 'High'];
  final List<String> orderByList = ['Newest', 'Oldest'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    _fromDateController.text = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
    _toDateController.text = DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    setState(() {
      _selectedCategory = 0;
      _selectedStatus = "Open";
      _selectedPriority = null;
      _selectedSeverity = null;
      _selectedOrderBy = "Newest";
      _fromDateController.text = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
      _toDateController.text = DateFormat('yyyy-MM-dd').format(now);
    });
    if (widget.onClear != null) widget.onClear!();
  }

  void _applyFilters() {
    if (widget.onApply != null) {
      widget.onApply!(
        TicketFilterData(
          ticketCategoryId: _selectedCategory,
          status: _selectedStatus,
          priority: _selectedPriority,
          severity: _selectedSeverity,
          orderBy: _selectedOrderBy,
          fromDate: _fromDateController.text,
          toDate: _toDateController.text,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Category & Status
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Order By',
                      value: _selectedOrderBy,
                      items: orderByList,
                      onChanged: (value) =>
                          setState(() => _selectedOrderBy = value),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Status',
                      value: _selectedStatus,
                      items: statuses,
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Priority & Severity
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Priority',
                      value: _selectedPriority,
                      items: priorities,
                      onChanged: (value) =>
                          setState(() => _selectedPriority = value),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomDropdown(
                      hintText: 'Severity',
                      value: _selectedSeverity,
                      items: severities,
                      onChanged: (value) =>
                          setState(() => _selectedSeverity = value),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              // Date Range
              Row(
                children: [
                  Expanded(
                    child: CustomDateTimeField(
                      hintText: 'From Date',
                      controller: _fromDateController,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomDateTimeField(
                      hintText: 'To Date',
                      controller: _toDateController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearFilters,
                      icon: Icon(Icons.refresh, size: 20),
                      label: Text('Clear All'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF1976D2),
                        side: BorderSide(color: Color(0xFF1976D2), width: 1.5),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _applyFilters,
                      icon: Icon(Icons.search, size: 20),
                      label: Text('Apply Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
}

class TicketFilterData {
  final int ticketCategoryId;
  final String? status;
  final String? priority;
  final String? severity;
  final String? orderBy;
  final String fromDate;
  final String toDate;

  TicketFilterData({
    required this.ticketCategoryId,
    this.status,
    this.priority,
    this.severity,
    this.orderBy,
    required this.fromDate,
    required this.toDate,
  });
}
