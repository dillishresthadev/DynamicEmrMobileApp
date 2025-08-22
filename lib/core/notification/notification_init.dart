import 'dart:developer';

import 'package:dynamic_emr/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationInitializer {
  final NotificationRemoteDatasource _datasource;

  NotificationInitializer(this._datasource);

  Future<void> initFCM({String? applicationId}) async {
    try {
      // Get the FCM token
      final token = await FirebaseMessaging.instance.getToken();

      log("FCM token :$token");

      if (token != null) {
        if (applicationId != null && applicationId.isNotEmpty) {
          // User is logged in → send with ApplicationId
          await _datasource.sendFcmDeviceToken(token, applicationId);
        } else {
          // Anonymous device
          await _datasource.sendFcmDeviceTokenAnonymous(token);
        }
      }

      // Always listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        if (applicationId != null && applicationId.isNotEmpty) {
          await _datasource.sendFcmDeviceToken(newToken, applicationId);
        } else {
          await _datasource.sendFcmDeviceTokenAnonymous(newToken);
        }
      });
    } catch (e) {
      log("Error initializing FCM token: $e");
    }
  }
}
