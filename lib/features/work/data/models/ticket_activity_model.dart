import 'package:dynamic_emr/features/work/domain/entities/ticket_activity_entity.dart';

class TicketActivityModel extends TicketActivityEntity {
  TicketActivityModel({
    required super.id,
    required super.ticketId,
    required super.activity,
    super.comment,
    required super.ticketAction,
    required super.commentDate,
    required super.replyBy,
    required super.replyOn,
    required super.userType,
    required super.applicationUserId,
    required super.isActive,
    super.attachmentFiles,
    required super.attachedDocuments,
    required super.insertUser,
    required super.insertTime,
    super.updateUser,
    super.updateTime,
  });

  factory TicketActivityModel.fromJson(Map<String, dynamic> json) =>
      TicketActivityModel(
        id: json["id"] ?? 0,
        ticketId: json["ticketId"] ?? 0,
        activity: json["activity"] ?? "",
        comment: json["comment"], // Already dynamic/nullable
        ticketAction: json["ticketAction"] ?? "",
        commentDate: json["commentDate"] != null
            ? DateTime.parse(json["commentDate"])
            : DateTime.now(),
        replyBy: json["replyBy"] ?? "",
        replyOn: json["replyOn"] != null
            ? DateTime.parse(json["replyOn"])
            : DateTime.now(),
        userType: json["userType"] ?? "",
        applicationUserId: json["applicationUserId"] ?? "",
        isActive: json["isActive"] ?? false,
        attachmentFiles: json["attachmentFiles"],
        attachedDocuments: json["attachedDocuments"] != null
            ? List<dynamic>.from(json["attachedDocuments"].map((x) => x))
            : <dynamic>[],
        insertUser: json["insertUser"] ?? "",
        insertTime: json["insertTime"] != null
            ? DateTime.parse(json["insertTime"])
            : DateTime.now(),
        updateUser: json["updateUser"],
        updateTime: json["updateTime"],
      );
  Map<String, dynamic> toJson() => {
    "id": id,
    "ticketId": ticketId,
    "activity": activity,
    "comment": comment,
    "ticketAction": ticketAction,
    "commentDate": commentDate.toIso8601String(),
    "replyBy": replyBy,
    "replyOn": replyOn.toIso8601String(),
    "userType": userType,
    "applicationUserId": applicationUserId,
    "isActive": isActive,
    "attachmentFiles": attachmentFiles,
    "attachedDocuments": List<dynamic>.from(attachedDocuments.map((x) => x)),
    "insertUser": insertUser,
    "insertTime": insertTime.toIso8601String(),
    "updateUser": updateUser,
    "updateTime": updateTime,
  };
}
