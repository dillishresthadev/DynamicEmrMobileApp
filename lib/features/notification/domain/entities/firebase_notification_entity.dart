class FirebaseNotificationEntity {
  final String title;
  final String body;
  final Map<String, dynamic>? data;

  FirebaseNotificationEntity({
    required this.title,
    required this.body,
    this.data,
  });
}