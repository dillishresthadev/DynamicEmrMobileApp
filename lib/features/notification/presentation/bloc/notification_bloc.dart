import 'dart:async';
import 'dart:developer';

import 'package:dynamic_emr/features/notification/domain/usecases/mark_all_notification_as_read_usecase.dart';
import 'package:dynamic_emr/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:dynamic_emr/features/notification/domain/usecases/send_fcm_device_token_anonymous_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendFcmDeviceTokenAnonymousUsecase sendFcmDeviceTokenAnonymousUsecase;
  final MarkAllNotificationAsReadUsecase markAllNotificationAsReadUsecase;
  final MarkNotificationAsReadUsecase markNotificationAsReadUsecase;
  NotificationBloc({
    required this.sendFcmDeviceTokenAnonymousUsecase,
    required this.markAllNotificationAsReadUsecase,
    required this.markNotificationAsReadUsecase,
  }) : super(NotificationState()) {
    on<SendFcmDeviceTokenAnonymousEvent>(_onSendFcmDeviceTokenAnonymous);
    on<MarkAllNotificationAsReadEvent>(_onMarkAllNotificationAsRead);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
  }

  Future<void> _onSendFcmDeviceTokenAnonymous(
    SendFcmDeviceTokenAnonymousEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: NotificationStatus.laoding));
      final deviceTokenSend = await sendFcmDeviceTokenAnonymousUsecase.call(
        event.deviceToken,
      );

      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      log("Error on Bloc : While sending FCM device token anonymous : $e");
      emit(
        state.copyWith(status: NotificationStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> _onMarkAllNotificationAsRead(
    MarkAllNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: NotificationStatus.laoding));

      final markAllNotificationAsRead = await markAllNotificationAsReadUsecase
          .call();
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      log("Error on bloc [_onMarkAllNotificationAsRead] : $e");
      emit(
        state.copyWith(status: NotificationStatus.error, message: e.toString()),
      );
    }
  }

  FutureOr<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: NotificationStatus.laoding));

      final markAllNotificationAsRead = await markNotificationAsReadUsecase
          .call(event.notificationId);
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      log("Error on bloc [_onMarkNotificationAsRead] : $e");
      emit(
        state.copyWith(status: NotificationStatus.error, message: e.toString()),
      );
    }
  }
}
