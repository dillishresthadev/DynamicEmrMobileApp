import 'package:dynamic_emr/core/extension/date_extension.dart';
import 'package:dynamic_emr/features/Leave/domain/entities/leave_application_entity.dart';
import 'package:dynamic_emr/features/Leave/presentation/bloc/leave_bloc.dart';
import 'package:dynamic_emr/features/Leave/presentation/widgets/leave_application_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovedLeavesTab extends StatefulWidget {
  const ApprovedLeavesTab({super.key});

  @override
  State<ApprovedLeavesTab> createState() => _ApprovedLeavesTabState();
}

class _ApprovedLeavesTabState extends State<ApprovedLeavesTab> {
  @override
  void initState() {
    super.initState();
    context.read<LeaveBloc>().add(ApprovedLeaveListEvent());
  }

  Future<void> _refreshData() async {
    context.read<LeaveBloc>().add(ApprovedLeaveListEvent());
  }

  void _showLeaveDetailsBottomSheet(LeaveApplicationEntity leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.7, // 70% of screen height
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: LeaveDetailsBottomSheet(leave: leave),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              if (state.approvedLeaveStatus == LeaveStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.approvedLeaveStatus ==
                  LeaveStatus.approvedLeaveLoadSuccess) {
                final approvedLeave = state.approvedLeave;

                approvedLeave.sort(
                  (a, b) => b.applicationDate.compareTo(
                    a.applicationDate,
                  ), // Recent first according to applicationDate
                );

                return ListView.builder(
                  itemCount: approvedLeave.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < approvedLeave.length - 1 ? 8.0 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            _showLeaveDetailsBottomSheet(approvedLeave[index]),
                        child: LeaveApplicationCardWidget(
                          leave: approvedLeave[index],
                        ),
                      ),
                    );
                  },
                );
              } else if (state.approvedLeaveStatus ==
                  LeaveStatus.approvedLeaveLoadError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("No approved leaves found"));
            },
          ),
        ),
      ),
    );
  }
}

class LeaveDetailsBottomSheet extends StatelessWidget {
  final LeaveApplicationEntity leave;

  const LeaveDetailsBottomSheet({super.key, required this.leave});

  bool isValidPrimaryDate(String? date) {
    if (date == null) return false;
    final parsed = DateTime.tryParse(date);
    return parsed != null && parsed.year != 1; // "0001-01-01" treated as null
  }

  @override
  Widget build(BuildContext context) {
    final hasPrimary =
        isValidPrimaryDate(leave.fromDate) && isValidPrimaryDate(leave.toDate);
    final hasExtended =
        leave.extendedFromDate != null && leave.extendedToDate != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: leave.isApproved
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    leave.isApproved ? Icons.check_circle : Icons.schedule,
                    color: leave.isApproved ? Colors.green : Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leave Application Details',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (leave.leaveNo.isNotEmpty == true)
                        Text(
                          'Leave No: ${leave.leaveNo}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: leave.isApproved
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    leave.isApproved ? 'Approved' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: leave.isApproved
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Information
                  if (leave.employeeDisplayName.isNotEmpty == true)
                    _buildInfoSection('Employee Information', [
                      _buildInfoRow(
                        'Employee',
                        leave.employeeDisplayName,
                        Icons.person,
                      ),
                    ]),

                  // Application Information
                  _buildInfoSection('Application Information', [
                    _buildInfoRow(
                      'Application Date',
                      DateTime.parse(leave.applicationDate).toDMMMYYYY(),
                      Icons.event_note,
                    ),
                    if (leave.applicationDateNp.isNotEmpty == true)
                      _buildInfoRow(
                        'Application Date (NP)',
                        leave.applicationDateNp,
                        Icons.calendar_today,
                      ),
                    if (leave.status.isNotEmpty == true)
                      _buildInfoRow('Status', leave.status, Icons.info),
                  ]),

                  // Primary Leave Information
                  if (hasPrimary) ...[
                    _buildInfoSection('Primary Leave', [
                      if (leave.leaveTypeName.isNotEmpty == true)
                        _buildInfoRow(
                          'Leave Type',
                          leave.leaveTypeName,
                          Icons.category,
                        ),
                      _buildInfoRow(
                        'From Date',
                        isValidPrimaryDate(leave.fromDate)
                            ? DateTime.parse(leave.fromDate).toDMMMYYYY()
                            : '',

                        Icons.date_range,
                      ),
                      _buildInfoRow(
                        'To Date',
                        isValidPrimaryDate(leave.toDate)
                            ? DateTime.parse(leave.toDate).toDMMMYYYY()
                            : '',
                        Icons.date_range,
                      ),
                      if (leave.fromDateNp.isNotEmpty == true)
                        _buildInfoRow(
                          'From Date (NP)',
                          leave.fromDateNp,
                          Icons.calendar_today,
                        ),
                      if (leave.toDateNp.isNotEmpty == true)
                        _buildInfoRow(
                          'To Date (NP)',
                          leave.toDateNp,
                          Icons.calendar_today,
                        ),
                      if (leave.halfDayStatus?.isNotEmpty == true)
                        _buildInfoRow(
                          'Half Day Status',
                          leave.halfDayStatus!,
                          Icons.schedule,
                        ),
                      _buildInfoRow(
                        'Total Days',
                        '${leave.totalLeaveDays} day${leave.totalLeaveDays > 1 ? "s" : ""}',
                        Icons.timeline,
                      ),
                    ]),
                  ],

                  // Extended Leave Information
                  if (hasExtended) ...[
                    _buildInfoSection('Extended Leave', [
                      if (leave.extendedLeaveTypeName?.isNotEmpty == true)
                        _buildInfoRow(
                          'Extended Leave Type',
                          leave.extendedLeaveTypeName!,
                          Icons.category,
                        ),
                      _buildInfoRow(
                        'Extended From Date',
                        DateTime.parse(leave.extendedFromDate!).toDMMMYYYY(),
                        Icons.date_range,
                      ),
                      _buildInfoRow(
                        'Extended To Date',
                        DateTime.parse(leave.extendedToDate!).toDMMMYYYY(),
                        Icons.date_range,
                      ),
                      if (leave.extendedFromDateNp?.isNotEmpty == true)
                        _buildInfoRow(
                          'Extended From Date (NP)',
                          leave.extendedFromDateNp!,
                          Icons.calendar_today,
                        ),
                      if (leave.extendedToDateNp?.isNotEmpty == true)
                        _buildInfoRow(
                          'Extended To Date (NP)',
                          leave.extendedToDateNp!,
                          Icons.calendar_today,
                        ),
                      if (leave.extendedHalfDayStatus?.isNotEmpty == true)
                        _buildInfoRow(
                          'Extended Half Day Status',
                          leave.extendedHalfDayStatus!,
                          Icons.schedule,
                        ),
                      _buildInfoRow(
                        'Extended Total Days',
                        '${leave.extendedTotalLeaveDays} day${leave.extendedTotalLeaveDays > 1 ? "s" : ""}',
                        Icons.timeline,
                      ),
                    ]),
                  ],

                  // Reason
                  if (leave.reason.trim().isNotEmpty == true)
                    _buildInfoSection('Reason', [
                      _buildInfoRow(
                        'Leave Reason',
                        leave.reason,
                        Icons.description,
                      ),
                    ]),

                  // Approval Information
                  _buildApprovalSection(),

                  // Recommendation Information
                  _buildRecommendationSection(),

                  // Substitute Information
                  _buildSubstituteSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalSection() {
    final hasApprovalData =
        leave.isApproved ||
        leave.leaveApprovedBy?.isNotEmpty == true ||
        leave.approveRemarks?.isNotEmpty == true ||
        leave.leaveApprovedOn?.isNotEmpty == true ||
        leave.rejectedBy?.isNotEmpty == true;

    if (!hasApprovalData) return const SizedBox.shrink();

    List<Widget> approvalItems = [];

    approvalItems.add(
      _buildInfoRow(
        'Approval Status',
        leave.isApproved ? 'Approved' : 'Not Approved',
        Icons.approval,
      ),
    );

    if (leave.leaveApprovedBy?.isNotEmpty == true) {
      approvalItems.add(
        _buildInfoRow('Approved By', leave.leaveApprovedBy!, Icons.person),
      );
    }

    if (leave.leaveApprovedOn?.isNotEmpty == true) {
      approvalItems.add(
        _buildInfoRow(
          'Approved On',
          DateTime.parse(leave.leaveApprovedOn!).toDMMMYYYY(),
          Icons.date_range,
        ),
      );
    }

    if (leave.approveRemarks?.isNotEmpty == true) {
      approvalItems.add(
        _buildInfoRow('Approval Remarks', leave.approveRemarks!, Icons.comment),
      );
    }

    if (leave.rejectedBy?.isNotEmpty == true) {
      approvalItems.add(
        _buildInfoRow('Rejected By', leave.rejectedBy!, Icons.person),
      );
    }

    return _buildInfoSection('Approval Information', approvalItems);
  }

  Widget _buildRecommendationSection() {
    final hasRecommendationData =
        leave.isRecommendationApproved ||
        leave.recommendationStatus.isNotEmpty == true ||
        leave.recommendationApprovedBy?.isNotEmpty == true ||
        leave.recommendationApprovedOn?.isNotEmpty == true ||
        leave.recommendationRemarks?.isNotEmpty == true ||
        leave.recommendedByEmployeeName?.isNotEmpty == true;

    if (!hasRecommendationData) return const SizedBox.shrink();

    List<Widget> recommendationItems = [];

    if (leave.recommendationStatus.isNotEmpty == true) {
      recommendationItems.add(
        _buildInfoRow(
          'Recommendation Status',
          leave.recommendationStatus,
          Icons.thumb_up,
        ),
      );
    }

    recommendationItems.add(
      _buildInfoRow(
        'Recommendation Approved',
        leave.isRecommendationApproved ? 'Yes' : 'No',
        Icons.approval,
      ),
    );

    if (leave.recommendationApprovedBy?.isNotEmpty == true) {
      recommendationItems.add(
        _buildInfoRow(
          'Recommendation Approved By',
          leave.recommendationApprovedBy!,
          Icons.person,
        ),
      );
    }

    if (leave.recommendationApprovedOn?.isNotEmpty == true) {
      recommendationItems.add(
        _buildInfoRow(
          'Recommendation Approved On',
          DateTime.parse(leave.recommendationApprovedOn!).toDMMMYYYY(),
          Icons.date_range,
        ),
      );
    }

    if (leave.recommendationRemarks?.isNotEmpty == true) {
      recommendationItems.add(
        _buildInfoRow(
          'Recommendation Remarks',
          leave.recommendationRemarks!,
          Icons.comment,
        ),
      );
    }

    if (leave.recommendedByEmployeeName?.isNotEmpty == true) {
      recommendationItems.add(
        _buildInfoRow(
          'Recommended By',
          leave.recommendedByEmployeeName!,
          Icons.person,
        ),
      );
    }

    return _buildInfoSection('Recommendation Information', recommendationItems);
  }

  Widget _buildSubstituteSection() {
    final hasSubstituteData =
        leave.isSubstituteAccepted ||
        leave.substitutationStatus.isNotEmpty == true ||
        leave.substituteEmployeeName?.isNotEmpty == true ||
        leave.substituteAcceptRejectBy?.isNotEmpty == true ||
        leave.substituteAcceptRejectOn?.isNotEmpty == true ||
        leave.substituteRemarks?.isNotEmpty == true;

    if (!hasSubstituteData) return const SizedBox.shrink();

    List<Widget> substituteItems = [];

    if (leave.substitutationStatus.isNotEmpty == true) {
      substituteItems.add(
        _buildInfoRow(
          'Substitution Status',
          leave.substitutationStatus,
          Icons.swap_horiz,
        ),
      );
    }

    substituteItems.add(
      _buildInfoRow(
        'Substitute Accepted',
        leave.isSubstituteAccepted ? 'Yes' : 'No',
        Icons.approval,
      ),
    );

    if (leave.substituteEmployeeName?.isNotEmpty == true) {
      substituteItems.add(
        _buildInfoRow(
          'Substitute Employee',
          leave.substituteEmployeeName!,
          Icons.person,
        ),
      );
    }

    if (leave.substituteAcceptRejectBy?.isNotEmpty == true) {
      substituteItems.add(
        _buildInfoRow(
          'Substitute Action By',
          leave.substituteAcceptRejectBy!,
          Icons.person,
        ),
      );
    }

    if (leave.substituteAcceptRejectOn?.isNotEmpty == true) {
      substituteItems.add(
        _buildInfoRow(
          'Substitute Action On',
          DateTime.parse(leave.substituteAcceptRejectOn!).toDMMMYYYY(),
          Icons.date_range,
        ),
      );
    }

    if (leave.substituteRemarks?.isNotEmpty == true) {
      substituteItems.add(
        _buildInfoRow(
          'Substitute Remarks',
          leave.substituteRemarks!,
          Icons.comment,
        ),
      );
    }

    return _buildInfoSection('Substitute Information', substituteItems);
  }
}
