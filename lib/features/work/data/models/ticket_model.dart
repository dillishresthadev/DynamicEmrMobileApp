import 'dart:developer';

import 'package:dynamic_emr/features/work/domain/entities/ticket_entity.dart';

class TicketModel extends TicketEntity {
  TicketModel({
    required super.id,
    required super.ticketNo,
    required super.ticketNoSequence,
    required super.ticketYearSequence,
    required super.ticketMonthlySequence,
    required super.ticketDailySequence,
    required super.ticketMonthlyNpSequence,
    required super.ticketYearlyNpSequence,
    required super.ticketFySequence,
    required super.ticketYearlySequenceByCategory,
    required super.ticketMonthlySequenceByCategory,
    required super.ticketDailySequenceByCategory,
    required super.ticketNo2,
    required super.applicationUserId,
    required super.title,
    required super.description,
    required super.ticketDate,
    required super.status,
    required super.severity,
    required super.priority,
    required super.ticketCategoryId,
    required super.ticketCategoryName,
    required super.assignToEmployeeId,
    required super.assignedTo,
    required super.assignedOn,
    super.issueByEmployeeId,
    required super.issueBy,
    required super.issueOn,
    super.sessionTag,
    super.attachmentFiles,
    super.client,
    super.clientDesc,
    super.clientDesc2,
    super.dueDate,
    required super.attachedDocuments,
    required super.insertUser,
    required super.insertTime,
    required super.updateUser,
    super.updateTime,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: json["id"] ?? 0,
    ticketNo: json["ticketNo"] ?? "",
    ticketNoSequence: json["ticketNoSequence"] ?? 0,
    ticketYearSequence: json["ticketYearSequence"] ?? 0,
    ticketMonthlySequence: json["ticketMonthlySequence"] ?? 0,
    ticketDailySequence: json["ticketDailySequence"] ?? 0,
    ticketMonthlyNpSequence: json["ticketMonthlyNpSequence"] ?? 0,
    ticketYearlyNpSequence: json["ticketYearlyNpSequence"] ?? 0,
    ticketFySequence: json["ticketFySequence"] ?? 0,
    ticketYearlySequenceByCategory: json["ticketYearlySequenceByCategory"] ?? 0,
    ticketMonthlySequenceByCategory:
        json["ticketMonthlySequenceByCategory"] ?? 0,
    ticketDailySequenceByCategory: json["ticketDailySequenceByCategory"] ?? 0,
    ticketNo2: json["ticketNo2"] ?? "",
    applicationUserId: json["applicationUserId"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    ticketDate: _parseDate(json["ticketDate"]),
    client: json['client'] ?? "",
    clientDesc: json['clientDesc'] ?? "",
    clientDesc2: json['clientDesc2'] ?? "",
    dueDate: _parseNullableDate(json['dueDate']),
    status: json["status"] ?? "Open",
    severity: json["severity"] ?? "Medium",
    priority: json["priority"] ?? "Medium",
    ticketCategoryId: json["ticketCategoryId"] ?? 0,
    ticketCategoryName: json["ticketCategoryName"] ?? "",
    assignToEmployeeId: json["assignToEmployeeId"] ?? 0,
    assignedTo: json["assignedTo"] ?? "",
    assignedOn: _parseDate(json["assignedOn"]),
    issueByEmployeeId: json["issueByEmployeeId"],
    issueBy: json["issueBy"] ?? "",
    issueOn: _parseDate(json["issueOn"]),
    sessionTag: json["sessionTag"],
    attachmentFiles: json["attachmentFiles"],
    attachedDocuments: json["attachedDocuments"] != null
        ? List<String>.from(json["attachedDocuments"].map((x) => x ?? ""))
        : <String>[],
    insertUser: json["insertUser"] ?? "",
    insertTime: _parseDate(json["insertTime"]),
    updateUser: json["updateUser"] ?? "",
    updateTime: _parseNullableDate(json["updateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticketNo": ticketNo,
    "ticketNoSequence": ticketNoSequence,
    "ticketYearSequence": ticketYearSequence,
    "ticketMonthlySequence": ticketMonthlySequence,
    "ticketDailySequence": ticketDailySequence,
    "ticketMonthlyNpSequence": ticketMonthlyNpSequence,
    "ticketYearlyNpSequence": ticketYearlyNpSequence,
    "ticketFySequence": ticketFySequence,
    "ticketYearlySequenceByCategory": ticketYearlySequenceByCategory,
    "ticketMonthlySequenceByCategory": ticketMonthlySequenceByCategory,
    "ticketDailySequenceByCategory": ticketDailySequenceByCategory,
    "ticketNo2": ticketNo2,
    "applicationUserId": applicationUserId,
    "title": title,
    "description": description,
    "ticketDate": ticketDate.toIso8601String(),
    "status": status,
    "severity": severity,
    "priority": priority,
    "ticketCategoryId": ticketCategoryId,
    "ticketCategoryName": ticketCategoryName,
    "assignToEmployeeId": assignToEmployeeId,
    "assignedTo": assignedTo,
    "assignedOn": assignedOn.toIso8601String(),
    "issueByEmployeeId": issueByEmployeeId,
    "issueBy": issueBy,
    "issueOn": issueOn.toIso8601String(),
    "sessionTag": sessionTag,
    "attachmentFiles": attachmentFiles,
    "attachedDocuments": List<dynamic>.from(attachedDocuments.map((x) => x)),
    "insertUser": insertUser,
    "insertTime": insertTime.toIso8601String(),
    "updateUser": updateUser,
    "updateTime": updateTime?.toIso8601String(),
  };

  /// Safely parse a DateTime or fallback to DateTime.now()
  static DateTime _parseDate(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        log("⚠️ Invalid date format: $value");
      }
    }
    return DateTime.now();
  }

  /// Safely parse a nullable DateTime
  static DateTime? _parseNullableDate(dynamic value) {
    if (value != null && value.toString().isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        log("⚠️ Invalid nullable date format: $value");
      }
    }
    return null;
  }
}
