class TicketActivityEntity {
  final int id;
  final int ticketId;
  final String activity;
  final dynamic comment;
  final String ticketAction;
  final DateTime commentDate;
  final String replyBy;
  final DateTime replyOn;
  final String userType;
  final String applicationUserId;
  final bool isActive;
  final dynamic attachmentFiles;
  final List<String> attachedDocuments;
  final String insertUser;
  final DateTime insertTime;
  final dynamic updateUser;
  final dynamic updateTime;

  const TicketActivityEntity({
    required this.id,
    required this.ticketId,
    required this.activity,
    this.comment,
    required this.ticketAction,
    required this.commentDate,
    required this.replyBy,
    required this.replyOn,
    required this.userType,
    required this.applicationUserId,
    required this.isActive,
    this.attachmentFiles,
    required this.attachedDocuments,
    required this.insertUser,
    required this.insertTime,
    this.updateUser,
    this.updateTime,
  });
}
