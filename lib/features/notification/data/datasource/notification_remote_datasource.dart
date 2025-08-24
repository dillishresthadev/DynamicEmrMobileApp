import 'dart:developer';

import 'package:dynamic_emr/core/constants/api_constants.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/notification/data/models/notification_model.dart';
import 'package:dynamic_emr/features/notification/domain/entities/firebase_notification_entity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:dynamic_emr/injection.dart';

//  Background message handler for Firebase Messaging
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationRemoteDatasourceImpl._showLocalNotification(message);
}

abstract class NotificationRemoteDatasource {
  Future<(int notificationCount, List<NotificationModel> items)>
  getUserNotifications();

  // Future<void> sendFcmDeviceToken(String token, String applicationId);
  Future<void> sendFcmDeviceTokenAnonymous(String token);

  Stream<FirebaseNotificationEntity> listenNotification();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioHttpClient client;

  NotificationRemoteDatasourceImpl({required this.client});

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static bool _isFlutterLocalNotificationInitialized = false;

  /// Initialize notifications for foreground/background
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Setup local notifications
    await _setupFlutterNotifications();

    // Foreground listener
    FirebaseMessaging.onMessage.listen((message) {
      log("Foreground message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // Handle notification taps when app opened from background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Notification tapped. Data: ${message.data}");
    });
  }

  static Future<void> _setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final iosInitSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        log("Notification tapped with payload: ${details.payload}");
      },
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    // final android = notification?.android;

    String? title = notification?.title ?? message.data['title'];
    String? body = notification?.body ?? message.data['body'];

    log(
      "Message received. Notification: ${message.notification}, Data: ${message.data}",
    );

    if (title != null && body != null) {
      await _localNotifications.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  @override
  Future<(int, List<NotificationModel>)> getUserNotifications() async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final response = await client.get(
        "$baseUrl/${ApiConstants.getAllNotification}",
        token: accessToken,
      );

      final data = response['data'] as Map<String, dynamic>?;

      if (data == null) throw Exception("Invalid response format");

      final int notificationCount = data['notificationCount'] ?? 0;

      final notifications = (data['recentNotifications'] as List<dynamic>)
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      return (notificationCount, notifications);
    } catch (e) {
      log("Error fetching user notifications: $e");
      rethrow;
    }
  }

  @override
  Stream<FirebaseNotificationEntity> listenNotification() async* {
    yield* FirebaseMessaging.onMessage.map((message) {
      log("Notification received: ${message.notification?.title}");
      _showLocalNotification(message);
      return FirebaseNotificationEntity(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        data: message.data,
      );
    });
  }

  // @override
  // Future<void> sendFcmDeviceToken(String token, String applicationId) async {
  //   try {
  //     final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
  //     final accessToken = await injection<TokenSecureStorage>()
  //         .getAccessToken();

  //     final response = await client.post(
  //       "$baseUrl/${ApiConstants.sendFcmDeviceToken}",
  //       token: accessToken,
  //       body: {"Token": token, "ApplicationId": applicationId},
  //     );

  //     if (response['data'] is! bool) {
  //       throw Exception("Unexpected response format");
  //     }
  //   } catch (e) {
  //     log("Error sending FCM device token: $e");
  //     rethrow;
  //   }
  // }

  @override
  Future<void> sendFcmDeviceTokenAnonymous(String token) async {
    try {
      final baseUrl = await injection<ISecureStorage>().getHospitalBaseUrl();
      final accessToken = await injection<TokenSecureStorage>()
          .getAccessToken();
      final response = await client.post(
        "$baseUrl/${ApiConstants.sendFcmDeviceTokenAnonymous}",
        token: accessToken,
        body: {"Token": token},
      );

      if (response['data'] is! bool) {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      log("Error sending anonymous FCM device token: $e");
      rethrow;
    }
  }
}
