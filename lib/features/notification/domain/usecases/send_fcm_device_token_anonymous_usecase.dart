import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class SendFcmDeviceTokenAnonymousUsecase {
  final NotificationRepository repository;

  SendFcmDeviceTokenAnonymousUsecase({required this.repository});

  Future<void> call(String token) async {
    return await repository.sendFcmDeviceTokenAnonymous(token);
  }
}
