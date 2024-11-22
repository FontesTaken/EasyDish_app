import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';

Future<void> scheduleNotification({
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  print('Converted scheduled time: ${tz.TZDateTime.from(scheduledDate, tz.local)}');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      "timer_channel", // Use the same channel ID as in initialization
      "Timer Notifications",
      channelDescription: "Notifications for scheduled timers",
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // ID of the notification
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local), // Convert to local timezone
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
