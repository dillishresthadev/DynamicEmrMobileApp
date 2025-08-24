part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

final class SendFcmDeviceTokenAnonymousEvent extends NotificationEvent {
  final String deviceToken;

  const SendFcmDeviceTokenAnonymousEvent({required this.deviceToken});
  @override
  List<Object> get props => [deviceToken];
}

final class MarkNotificationAsReadEvent extends NotificationEvent{
  final String notificationId;

  const MarkNotificationAsReadEvent({required this.notificationId});
  @override
  List<Object> get props => [notificationId];
}
final class MarkAllNotificationAsReadEvent extends NotificationEvent{
}