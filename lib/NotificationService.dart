

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
  const AndroidInitializationSettings('mipmap/ic_launcher');
  var iosInitializationSettings = const DarwinInitializationSettings();
  void initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
        android: _androidInitializationSettings,
        iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(
      String title,
      String body,
      ) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('Test', 'TestOO',
        importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
}

class createLocalNotification {
  static final _notification = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'Test',
          'TestOO',
          importance: Importance.max,
        ));
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async =>
      _notification.show(id, title, body, await _notificationDetails(),
          payload: payload);
}
