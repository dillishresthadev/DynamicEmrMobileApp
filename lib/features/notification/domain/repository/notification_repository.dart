import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<(int notificationCount, List<NotificationEntity> items)>
  getUserNotifications();
  // Future<void> sendFcmDeviceToken(String token, String applicationId);

  /// Sends the FCM device token anonymously
  Future<void> sendFcmDeviceTokenAnonymous(String token);
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationAsRead();
  Future<int> getUnreadNotificationCount(String type);
  Stream<FirebaseNotificationEntity> listenNotification();
}
