import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';

Future<void> sendNotification(String title, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    'timer_channel',
    'Timer Notifications',
    channelDescription: 'This channel is used for timer notifications',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'timer',
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}
