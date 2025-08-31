import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/profile/domain/entities/employee_entity.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class WorkAndShiftDetailsScreen extends StatefulWidget {
  final EmployeeEntity employee;
  const WorkAndShiftDetailsScreen({super.key, required this.employee});

  @override
  State<WorkAndShiftDetailsScreen> createState() =>
      _WorkAndShiftDetailsScreenState();
}

class _WorkAndShiftDetailsScreenState extends State<WorkAndShiftDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Work and Shift Information",
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shift Information Section
              _buildShiftDetailsCard(employee),

              SizedBox(height: 12),
              // Work Details Section
              _buildWorkDetailsCard(employee),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiftDetailsCard(EmployeeEntity employee) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Shift Information",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.purple[700],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Primary Shift',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEnhancedInfoRow(
                    "Shift Name",
                    employee.employeeCurrentShift.primaryShiftName ?? "N/A",
                    Icons.label,
                  ),
                  _buildEnhancedInfoRow(
                    "Shift Time",
                    "${_formatTime(employee.employeeCurrentShift.primaryShiftStart)} - ${_formatTime(employee.employeeCurrentShift.primaryShiftEnd)}",
                    Icons.schedule,
                  ),
                ],
              ),
            ),

            // Extended Shift Section (if applicable)
            if (employee.employeeCurrentShift.hasMultiShift == true) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.update, color: Colors.orange[700], size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Extended Shift',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'MULTI-SHIFT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildEnhancedInfoRow(
                      "Shift Name",
                      employee.employeeCurrentShift.extendedShiftName ?? "N/A",
                      Icons.label,
                    ),
                    _buildEnhancedInfoRow(
                      "Shift Time",
                      "${_formatTime(employee.employeeCurrentShift.extendedShiftStart)} - ${_formatTime(employee.employeeCurrentShift.extendedShiftEnd)}",
                      Icons.schedule,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkDetailsCard(EmployeeEntity employee) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Work Details",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.green[700], size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Organization Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEnhancedInfoRow(
                    "Branch",
                    employee.workBranchTitle,
                    Icons.location_on,
                  ),

                  _buildEnhancedInfoRow(
                    "Department",
                    employee.departmentTitle,
                    Icons.group,
                  ),
                  _buildEnhancedInfoRow(
                    "TimeOffApprover",
                    employee.timeOffApproverTitle.split('-').last,
                    Icons.timer_off,
                  ),
                  _buildEnhancedInfoRow(
                    "Manager",
                    employee.managerTitle.split('-').last,
                    Icons.manage_accounts,
                  ),
                  _buildEnhancedInfoRow(
                    "Coach",
                    employee.coachTitle.split('-').last,
                    Icons.person,
                  ),
                  _buildEnhancedInfoRow(
                    "Shift Approver",
                    employee.shiftRequestApproverTitle.split('-').last,
                    Icons.approval_rounded,
                  ),
                  _buildEnhancedInfoRow(
                    "Designation",
                    employee.designationTitle,
                    Icons.work_outline,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact and Join Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_page,
                        color: Colors.blue[700],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEnhancedInfoRow(
                    "Joining Date",
                    _formatDate(employee.joiningDate),
                    Icons.event,
                  ),
                  _buildEnhancedInfoRow(
                    "Phone",
                    employee.mobileNumber,
                    Icons.phone,
                  ),
                  _buildEnhancedInfoRow(
                    "Email",
                    employee.homeEmail,
                    Icons.email,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";

    try {
      final parsedTime = DateTime.parse(time);
      return DateFormat("HH:mm").format(parsedTime);
    } catch (e) {
      return "N/A";
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat("MMM dd, yyyy").format(date);
  }

  Widget _buildEnhancedInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
