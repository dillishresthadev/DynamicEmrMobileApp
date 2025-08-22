import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<(int, List<NotificationEntity>)> getUserNotifications() {
    // TODO: implement getUserNotifications
    throw UnimplementedError();
  }

  @override
  Stream<FirebaseNotificationEntity> listenNotification() {
    // TODO: implement listenNotification
    throw UnimplementedError();
  }

  @override
  Future<void> sendFcmDeviceToken(String token, String applicationId) {
    // TODO: implement sendFcmDeviceToken
    throw UnimplementedError();
  }

  @override
  Future<void> sendFcmDeviceTokenAnonymous(String token) {
    // TODO: implement sendFcmDeviceTokenAnonymous
    throw UnimplementedError();
  }
}
