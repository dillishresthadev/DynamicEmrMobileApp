import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class ListenNotificationUsecase {
  final NotificationRepository repository;

  ListenNotificationUsecase({required this.repository});

  Stream<FirebaseNotificationEntity> call() {
    return repository.listenNotification();
  }
}
