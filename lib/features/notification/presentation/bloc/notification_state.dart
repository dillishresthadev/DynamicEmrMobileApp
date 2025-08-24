part of 'notification_bloc.dart';

enum NotificationStatus {initial, laoding,success,error}

final class NotificationState extends Equatable {
  final NotificationStatus status;
  final String? message;

  const NotificationState({ this.status = NotificationStatus.initial,  this.message = ''});

  NotificationState copyWith({
    NotificationStatus? status,
    String? message,
  }){
    return NotificationState(status: status?? this.status, message: message ?? this.message);
  }
  @override
  List<Object?> get props =>[status,message];
}