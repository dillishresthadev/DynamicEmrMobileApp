import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository repository;

  MarkNotificationAsReadUsecase({required this.repository});

  Future<void> call(String notificationId) {
    return repository.markNotificationAsRead(notificationId);
  }
}
