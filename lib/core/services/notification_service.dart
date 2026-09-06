import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  final ApiService _apiService = ApiService();

  final LocalStorageService _storage =
  LocalStorageService();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'spendsmart_notifications',
    'SpendSmart Notifications',
    description: 'Notifications from SpendSmart',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await _initializeLocalNotifications();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      'Notification permission status: '
          '${settings.authorizationStatus}',
    );

    final token = await _messaging.getToken();

    print('FCM Token: $token');

    if (token != null) {
      await syncToken();
    }

    FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    _messaging.onTokenRefresh.listen((newToken) async {
      print('FCM Token refreshed: $newToken');

      await syncToken();
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(

      settings: initializationSettings,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _handleForegroundMessage(
      RemoteMessage message,
      ) async {
    print(
      'Foreground notification received: '
          '${message.notification?.title}',
    );

    final notification = message.notification;

    if (notification == null) {
      return;
    }

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  Future<void> syncToken() async {
    try {
      final fcmToken = await _messaging.getToken();

      if (fcmToken == null) {
        print('FCM token is null.');
        return;
      }

      final authToken = await _storage.getToken();

      if (authToken == null) {
        print('No authentication token found.');
        return;
      }

      final response = await _apiService.put(
        ApiConstants.fcmToken,
        {
          'fcmToken': fcmToken,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response['statusCode'] == 200) {
        print(
          'FCM token synced with backend successfully.',
        );
      } else {
        print(
          'Failed to sync FCM token: '
              '${response['data']}',
        );
      }
    } catch (error) {
      print('FCM token sync error: $error');
    }
  }
}