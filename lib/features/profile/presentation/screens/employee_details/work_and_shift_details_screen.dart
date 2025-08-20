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
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(
        title: "Work and Shift Information",
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shift Information
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Shift Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              // Work Details Card
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          "Primary ShiftName",
                          employee.employeeCurrentShift.primaryShiftName ??
                              "N/A",
                        ),
                        _buildInfoRow(
                          "Primary Shift Time",
                          "${_formatTime(employee.employeeCurrentShift.primaryShiftStart)} - ${_formatTime(employee.employeeCurrentShift.primaryShiftEnd)}",
                        ),
                        if (employee.employeeCurrentShift.hasMultiShift ==
                            true) ...[
                          _buildInfoRow(
                            "ExtendedShift Name",
                            employee.employeeCurrentShift.extendedShiftName ??
                                "N/A",
                          ),
                          _buildInfoRow(
                            "ExtendedShift Time",
                            "${_formatTime(employee.employeeCurrentShift.extendedShiftStart)} - ${_formatTime(employee.employeeCurrentShift.extendedShiftEnd)}",
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Work Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              // Work Details Card
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Branch", employee.workBranchTitle),
                        _buildInfoRow("Department", "employee"),
                        _buildInfoRow("Designation", employee.designationTitle),
                        _buildInfoRow(
                          "Date of Joining",
                          employee.joiningDate.toString(),
                        ),
                        _buildInfoRow("Phone Number", employee.mobileNumber),
                        _buildInfoRow("Email", employee.homeEmail),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Authorities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Supervisor", "employee"),
                        _buildInfoRow("Expense Approver", "employee"),
                        _buildInfoRow("Time off Approver", "employee"),
                        _buildInfoRow("Coach", "employee"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";

    try {
      final parsedTime = DateTime.parse(time);
      return DateFormat("HH:mm").format(parsedTime); // Formats to hh:mm
    } catch (e) {
      return "N/A"; // In case of parsing errors, return N/A
    }
  }

  /// **Reusable method for displaying key-value pairs inside a card**
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 30),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 8.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 14),
                softWrap: true,
                // overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                // Aligns text to the right
              ),
            ),
          ),
        ],
      ),
    );
  }
}
