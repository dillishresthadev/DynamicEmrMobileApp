import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveApplicationHistoryScreen extends StatefulWidget {
  const LeaveApplicationHistoryScreen({super.key});

  @override
  State<LeaveApplicationHistoryScreen> createState() =>
      _LeaveApplicationHistoryScreenState();
}

class _LeaveApplicationHistoryScreenState
    extends State<LeaveApplicationHistoryScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> leaveHistory = [];

  @override
  void initState() {
    super.initState();
    _loadLeaveHistory();
  }

  void _loadLeaveHistory() {
    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        leaveHistory = _getMockData();
      });
    });
  }

  List<Map<String, dynamic>> _getMockData() {
    return [
      {
        "id": 1356,
        "applicationDate": "2025-08-18T09:05:22.7377527",
        "applicationDateNp": "2082/05/02",
        "leaveTypeId": 1,
        "employeeId": 65,
        "fromDate": "2025-08-18T00:00:00",
        "fromDateNp": "2082/05/02",
        "toDate": "2025-08-21T00:00:00",
        "toDateNp": "2082/05/05",
        "halfDayStatus": "On Start",
        "totalLeaveDays": 4.00,
        "extendedFromDate": "2025-08-18T00:00:00",
        "extendedToDate": "2025-08-21T00:00:00",
        "extendedFromDateNp": "2082/05/02",
        "extendedToDateNp": null,
        "extendedLeaveTypeId": 3,
        "extendedHalfDayStatus": null,
        "extendedTotalLeaveDays": 0.00,
        "reason": "casual leave",
        "status": "Open",
        "leaveTypeName": "Home Leave",
        "extendedLeaveTypeName": "Leave Without Pay",
        "employeeDisplayName": "HRM-0064-ASG-Chudaraj paudyal (Assistant)",
        "isRecommendationApproved": false,
        "isApproved": false,
        "isSubstituteAccepted": false,
        "substitutationStatus": "Pending",
        "recommendationStatus": "Pending",
        "leaveNo": "H001-082/83-17",
        "isInValidForApproval": false,
        "leaveApprovedBy": null,
        "approveRemarks": null,
        "leaveApprovedOn": null,
        "rejectedBy": null,
        "recommendationApprovedBy": null,
        "recommendationApprovedOn": null,
        "recommendationRemarks": null,
        "substituteAcceptRejectBy": null,
        "substituteAcceptRejectOn": null,
        "substituteRemarks": null,
        "substituteEmployeeName": "HRM-6-Pranjal - ()",
        "recommendedByEmployeeName": null,
      },
    ];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'open':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> leave) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leave['leaveTypeName'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Leave #${leave['leaveNo'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(leave['status'] ?? 'Unknown'),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('From Date', _formatDate(leave['fromDate'])),
                _buildInfoRow('To Date', _formatDate(leave['toDate'])),
                _buildInfoRow(
                  'Days',
                  '${leave['totalLeaveDays']?.toInt() ?? 0} days',
                ),
                _buildInfoRow(
                  'Applied On',
                  _formatDate(leave['applicationDate']),
                ),
                _buildInfoRow('Reason', leave['reason'] ?? 'N/A'),

                if (leave['leaveApprovedBy'] != null) ...[
                  Divider(height: 24),
                  _buildInfoRow(
                    'Approved By',
                    leave['leaveApprovedBy'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Approved On',
                    _formatDate(leave['leaveApprovedOn']),
                  ),
                ],

                if (leave['substituteEmployeeName'] != null) ...[
                  Divider(height: 24),
                  _buildInfoRow(
                    'Substitute',
                    leave['substituteEmployeeName'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Sub. Status',
                    leave['substitutationStatus'] ?? 'N/A',
                  ),
                ],

                // Extended leave details
                if (leave['extendedFromDate'] != null &&
                    leave['extendedToDate'] != null &&
                    leave['extendedTotalLeaveDays'] > 0) ...[
                  Divider(height: 24),
                  Text(
                    'Extended Leave Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    'Extended From',
                    _formatDate(leave['extendedFromDate']),
                  ),
                  _buildInfoRow(
                    'Extended To',
                    _formatDate(leave['extendedToDate']),
                  ),
                  _buildInfoRow(
                    'Extended Days',
                    '${leave['extendedTotalLeaveDays']?.toInt() ?? 0} days',
                  ),
                  _buildInfoRow(
                    'Extended Type',
                    leave['extendedLeaveTypeName'] ?? 'N/A',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Leave History',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2196F3),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
            )
          : leaveHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No leave history found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _loadLeaveHistory();
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: leaveHistory.length,
                itemBuilder: (context, index) {
                  return _buildLeaveCard(leaveHistory[index]);
                },
              ),
            ),
    );
  }
}
