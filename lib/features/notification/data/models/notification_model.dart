import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.from,
    required super.fromEmail,
    required super.to,
    required super.toEmail,
    required super.title,
    required super.content,
    required super.mailDate,
    required super.hasAttachment,
    required super.starred,
    required super.viewed,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      from: json['from'] ?? '',
      fromEmail: json['fromEmail'] ?? '',
      to: json['to'] ?? '',
      toEmail: json['toEmail'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mailDate: json['mailDate'] ?? '',
      hasAttachment: json['hasAttachment'] ?? false,
      starred: json['starred'] ?? false,
      viewed: json['viewed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'fromEmail': fromEmail,
      'to': to,
      'toEmail': toEmail,
      'title': title,
      'content': content,
      'mailDate': mailDate,
      'hasAttachment': hasAttachment,
      'starred': starred,
      'viewed': viewed,
    };
  }
}
