import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class GetUserNotifications {
  final NotificationRepository repository;
  GetUserNotifications({required this.repository});

  Future<(int notificationCount, List<NotificationEntity> items)> call() async {
    return await repository.getUserNotifications();
  }
}
