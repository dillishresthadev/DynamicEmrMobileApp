class TicketEntity {
  final int id;
  final String ticketNo;
  final int ticketNoSequence;
  final int ticketYearSequence;
  final int ticketMonthlySequence;
  final int ticketDailySequence;
  final int ticketMonthlyNpSequence;
  final int ticketYearlyNpSequence;
  final int ticketFySequence;
  final int ticketYearlySequenceByCategory;
  final int ticketMonthlySequenceByCategory;
  final int ticketDailySequenceByCategory;
  final String ticketNo2;
  final String applicationUserId;
  final String title;
  final String description;
  final DateTime ticketDate;
  final String status;
  final String severity;
  final String priority;
  final int ticketCategoryId;
  final String ticketCategoryName;
  final int assignToEmployeeId;
  final String assignedTo;
  final DateTime assignedOn;
  final dynamic issueByEmployeeId;
  final String issueBy;
  final DateTime issueOn;
  final dynamic sessionTag;
  final dynamic attachmentFiles;
  final List<String> attachedDocuments;
  final String insertUser;
  final DateTime insertTime;
  final String updateUser;
  final DateTime? updateTime;

  const TicketEntity({
    required this.id,
    required this.ticketNo,
    required this.ticketNoSequence,
    required this.ticketYearSequence,
    required this.ticketMonthlySequence,
    required this.ticketDailySequence,
    required this.ticketMonthlyNpSequence,
    required this.ticketYearlyNpSequence,
    required this.ticketFySequence,
    required this.ticketYearlySequenceByCategory,
    required this.ticketMonthlySequenceByCategory,
    required this.ticketDailySequenceByCategory,
    required this.ticketNo2,
    required this.applicationUserId,
    required this.title,
    required this.description,
    required this.ticketDate,
    required this.status,
    required this.severity,
    required this.priority,
    required this.ticketCategoryId,
    required this.ticketCategoryName,
    required this.assignToEmployeeId,
    required this.assignedTo,
    required this.assignedOn,
    this.issueByEmployeeId,
    required this.issueBy,
    required this.issueOn,
    this.sessionTag,
    this.attachmentFiles,
    required this.attachedDocuments,
    required this.insertUser,
    required this.insertTime,
    required this.updateUser,
    this.updateTime,
  });

}
