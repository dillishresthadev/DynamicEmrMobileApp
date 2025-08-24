import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationAsReadUsecase {
  final NotificationRepository repository;

  MarkAllNotificationAsReadUsecase({required this.repository});

  Future<void> call() {
    return repository.markAllNotificationAsRead();
  }
}
