import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class GetUnreadNotificationCountUsecase {
  final NotificationRepository repository;

  GetUnreadNotificationCountUsecase({required this.repository});

  Future<int> call(String type) {
    return repository.getUnreadNotificationCount(type);
  }
}
