import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String from;
  final String fromEmail;
  final String to;
  final String toEmail;
  final String title;
  final String content;
  final String mailDate; // keep as String since API returns "yesterday"
  final bool hasAttachment;
  final bool starred;
  final bool viewed;

  const NotificationEntity({
    required this.id,
    required this.from,
    required this.fromEmail,
    required this.to,
    required this.toEmail,
    required this.title,
    required this.content,
    required this.mailDate,
    required this.hasAttachment,
    required this.starred,
    required this.viewed,
  });

  @override
  List<Object?> get props => [id, title, content, viewed, starred];
}
