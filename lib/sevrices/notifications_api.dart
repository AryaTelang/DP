import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'Bachatcards', 'Important Notifications',
          channelDescription:
              'This channel is required to recieve exciting offers and rewards from the app',
          importance: Importance.max,
          largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher")),
      iOS: DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      onNotifications.add(payload.toString());
    });
  }

  void notificationPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future showNotification(
          {String? title, String? body, String? payload}) async =>
      _notifications.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title,
          body, _notificationDetails(),
          payload: payload);

  Future<void> createChannel() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'Bachatcards',
          'Important Notifications',
          description:
              'This channel is required to recieve exciting offers and rewards from the app',
          importance: Importance.max,
        ));
  }
}
