import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<(int notificationCount, List<NotificationEntity> items)>
  getUserNotifications();
  Future<void> sendFcmDeviceToken(String token, String applicationId);

  /// Sends the FCM device token anonymously (for unauthenticated users)
  Future<void> sendFcmDeviceTokenAnonymous(String token);
  Stream<FirebaseNotificationEntity> listenNotification();
}
