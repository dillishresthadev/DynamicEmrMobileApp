import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveApplicationHistoryScreen extends StatefulWidget {
  final int contractId;
  final int fiscalYearId;
  const LeaveApplicationHistoryScreen({
    super.key,
    required this.contractId,
    required this.fiscalYearId,
  });

  @override
  State<LeaveApplicationHistoryScreen> createState() =>
      _LeaveApplicationHistoryScreenState();
}

class _LeaveApplicationHistoryScreenState
    extends State<LeaveApplicationHistoryScreen> {
  @override
  void initState() {
    context.read<LeaveBloc>().add(
      GetLeaveHistoryByContractIdFiscalYearIdEvent(
        contractId: widget.contractId,
        fiscalYearId: widget.fiscalYearId,
      ),
    );
    super.initState();
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
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
        ),
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

  Widget _buildLeaveCard(dynamic leave) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                        leave.leaveTypeName ?? 'N/A',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Leave #${leave.leaveNo ?? 'N/A'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(leave.status ?? 'Unknown'),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('From Date', _formatDate(leave.fromDate)),
                _buildInfoRow('To Date', _formatDate(leave.toDate)),
                _buildInfoRow(
                  'Days',
                  '${leave.totalLeaveDays?.toInt() ?? 0} days',
                ),
                _buildInfoRow('Applied On', _formatDate(leave.applicationDate)),
                _buildInfoRow('Reason', leave.reason ?? 'N/A'),

                if (leave.leaveApprovedBy != null) ...[
                  Divider(height: 24),
                  _buildInfoRow('Approved By', leave.leaveApprovedBy ?? 'N/A'),
                  _buildInfoRow(
                    'Approved On',
                    _formatDate(leave.leaveApprovedOn),
                  ),
                ],

                if (leave.substituteEmployeeName != null) ...[
                  Divider(height: 24),
                  _buildInfoRow(
                    'Substitute',
                    leave.substituteEmployeeName ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Sub. Status',
                    leave.substitutationStatus ?? 'N/A',
                  ),
                ],

                if (leave.extendedFromDate != null &&
                    leave.extendedToDate != null &&
                    (leave.extendedTotalLeaveDays ?? 0) > 0) ...[
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
                    _formatDate(leave.extendedFromDate),
                  ),
                  _buildInfoRow(
                    'Extended To',
                    _formatDate(leave.extendedToDate),
                  ),
                  _buildInfoRow(
                    'Extended Days',
                    '${leave.extendedTotalLeaveDays?.toInt() ?? 0} days',
                  ),
                  _buildInfoRow(
                    'Extended Type',
                    leave.extendedLeaveTypeName ?? 'N/A',
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
      appBar: DynamicEMRAppBar(
        title: "Leave History",
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.leaveApplicationHistoryStatus == LeaveStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
            );
          } else if (state.leaveApplicationHistory.isEmpty) {
            return Center(
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
            );
          } else if (state.leaveApplicationHistoryStatus ==
              LeaveStatus.leaveApplicationHistoryLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeaveBloc>().add(
                  GetLeaveHistoryByContractIdFiscalYearIdEvent(
                    contractId: widget.contractId,
                    fiscalYearId: widget.fiscalYearId,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.leaveApplicationHistory.length,
                      itemBuilder: (context, index) {
                        final leave = state.leaveApplicationHistory[index];
                        return _buildLeaveCard(leave);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state.leaveApplicationHistoryStatus ==
              LeaveStatus.leaveApplicationHistoryError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(child: Text("Error un known ${state.status}"));
        },
      ),
    );
  }
}
