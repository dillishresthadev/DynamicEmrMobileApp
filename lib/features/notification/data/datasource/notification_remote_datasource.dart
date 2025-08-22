import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/notification/data/models/notification_model.dart';
import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dynamic_emr/injection.dart';

abstract class NotificationRemoteDatasource {
  Future<(int notificationCount, List<NotificationModel> items)>
  getUserNotifications();
  Future<void> sendFcmDeviceToken(String token, String applicationId);
  Future<void> sendFcmDeviceTokenAnonymous(String token);
  // listening alltime so stream not future .. no need of model so used entity only
  Stream<FirebaseNotificationEntity> listenNotification();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioHttpClient client;

  NotificationRemoteDatasourceImpl({required this.client});
  @override
  Future<(int, List<NotificationModel>)> getUserNotifications() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.get(
        "$baseUrl/${ApiConstants.getAllNotification}",
      );

      final data = response['data'];

      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      final int notificationCount = data['notificationCount'] ?? 0;

      final List<NotificationModel> notifications =
          (data['recentNotifications'] as List<dynamic>)
              .map((json) => NotificationModel.fromJson(json))
              .toList();

      return (notificationCount, notifications);
    } catch (e) {
      log("Error fetching user notifications $e");
      rethrow;
    }
  }

  @override
  Stream<FirebaseNotificationEntity> listenNotification() async* {
    // Foreground notifications
    yield* FirebaseMessaging.onMessage.map((RemoteMessage message) {
      log("Notification Title : ${message.notification?.title}");
      return FirebaseNotificationEntity(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        data: message.data,
      );
    });

    // Background & terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // For deep linking or navigation handling
    });
  }

  @override
  Future<void> sendFcmDeviceToken(String token, String applicationId) async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.post(
        "$baseUrl/${ApiConstants.sendFcmDeviceToken}",
        body: {"Token": token, "ApplicationId": applicationId},
      );
      if (response['data'] is bool) {
        return response['data'];
      }
      throw Exception("Unexpected response format");
    } catch (e) {
      log("Error sending deviceFCMToken $e");
      rethrow;
    }
  }

  @override
  Future<void> sendFcmDeviceTokenAnonymous(String token) async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();

      final response = await client.post(
        "$baseUrl/${ApiConstants.sendFcmDeviceToken}",
        body: {"Token": token},
      );
      if (response['data'] is bool) {
        return response['data'];
      }
      throw Exception("Unexpected response format");
    } catch (e) {
      log("Error sending deviceFCMToken $e");
      rethrow;
    }
  }
}
