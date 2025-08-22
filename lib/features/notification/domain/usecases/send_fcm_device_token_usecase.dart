import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';

class SendFcmDeviceTokenUsecase {
  final NotificationRepository repository;
  SendFcmDeviceTokenUsecase({required this.repository});

  Future<void> call(String token, String applicationId) async {
    return await repository.sendFcmDeviceToken(token, applicationId);
  }
}
