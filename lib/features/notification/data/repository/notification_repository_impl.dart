import 'dart:developer';

import 'package:dynamic_emr/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/entities/notification_entity.dart';
import 'package:dynamic_emr/features/notification/domain/repository/notification_repository.dart';
import 'package:dynamic_emr/features/notification/data/models/notification_model.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<(int, List<NotificationEntity>)> getUserNotifications() async {
    try {
      final (count, models) = await remoteDatasource.getUserNotifications();

      // Map NotificationModel to NotificationEntity
      final entities = models
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return (count, entities);
    } catch (e) {
      log("Error in getUserNotifications repository: $e");
      rethrow;
    }
  }

  @override
  Stream<FirebaseNotificationEntity> listenNotification() {
    try {
      return remoteDatasource.listenNotification();
    } catch (e) {
      log("Error in listenNotification repository: $e");
      rethrow;
    }
  }

  @override
  Future<void> sendFcmDeviceToken(String token, String applicationId) async {
    try {
      await remoteDatasource.sendFcmDeviceToken(token, applicationId);
    } catch (e) {
      log("Error in sendFcmDeviceToken repository: $e");
      rethrow;
    }
  }

  @override
  Future<void> sendFcmDeviceTokenAnonymous(String token) async {
    try {
      await remoteDatasource.sendFcmDeviceTokenAnonymous(token);
    } catch (e) {
      log("Error in sendFcmDeviceTokenAnonymous repository: $e");
      rethrow;
    }
  }
}
