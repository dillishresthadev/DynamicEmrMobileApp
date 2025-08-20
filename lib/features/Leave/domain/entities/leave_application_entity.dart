class LeaveApplicationEntity {
  final int id;
  final String applicationDate;
  final String applicationDateNp;
  final int leaveTypeId;
  final int employeeId;
  final String fromDate;
  final String fromDateNp;
  final String toDate;
  final String toDateNp;
  final dynamic halfDayStatus;
  final double totalLeaveDays;
  final dynamic extendedFromDate;
  final dynamic extendedToDate;
  final dynamic extendedFromDateNp;
  final dynamic extendedToDateNp;
  final dynamic extendedLeaveTypeId;
  final dynamic extendedHalfDayStatus;
  final double extendedTotalLeaveDays;
  final String reason;
  final String status;
  final String leaveTypeName;
  final dynamic extendedLeaveTypeName;
  final String employeeDisplayName;
  final bool isRecommendationApproved;
  final bool isApproved;
  final bool isSubstituteAccepted;
  final String substitutationStatus;
  final String recommendationStatus;
  final String leaveNo;
  final bool isInValidForApproval;
  final dynamic leaveApprovedBy;
  final dynamic approveRemarks;
  final dynamic leaveApprovedOn;
  final dynamic rejectedBy;
  final dynamic recommendationApprovedBy;
  final dynamic recommendationApprovedOn;
  final dynamic recommendationRemarks;
  final dynamic substituteAcceptRejectBy;
  final dynamic substituteAcceptRejectOn;
  final dynamic substituteRemarks;
  final dynamic substituteEmployeeName;
  final dynamic recommendedByEmployeeName;

  LeaveApplicationEntity({
    required this.id,
    required this.applicationDate,
    required this.applicationDateNp,
    required this.leaveTypeId,
    required this.employeeId,
    required this.fromDate,
    required this.fromDateNp,
    required this.toDate,
    required this.toDateNp,
    this.halfDayStatus,
    required this.totalLeaveDays,
    this.extendedFromDate,
    this.extendedToDate,
    this.extendedFromDateNp,
    this.extendedToDateNp,
    this.extendedLeaveTypeId,
    this.extendedHalfDayStatus,
    required this.extendedTotalLeaveDays,
    required this.reason,
    required this.status,
    required this.leaveTypeName,
    this.extendedLeaveTypeName,
    required this.employeeDisplayName,
    required this.isRecommendationApproved,
    required this.isApproved,
    required this.isSubstituteAccepted,
    required this.substitutationStatus,
    required this.recommendationStatus,
    required this.leaveNo,
    required this.isInValidForApproval,
    this.leaveApprovedBy,
    this.approveRemarks,
    this.leaveApprovedOn,
    this.rejectedBy,
    this.recommendationApprovedBy,
    this.recommendationApprovedOn,
    this.recommendationRemarks,
    this.substituteAcceptRejectBy,
    this.substituteAcceptRejectOn,
    this.substituteRemarks,
    this.substituteEmployeeName,
    this.recommendedByEmployeeName,
  });
}
