import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings, onDidReceiveNotificationResponse: (_) {});
    _initialized = true;
  }

  static Future<void> scheduleDailyReminder(int hour, int minute) async {
    await _plugin.cancelAll();
    await _plugin.zonedSchedule(
      0,
      'طريق الهداية',
      'أنت أقوى مما تظن — استمر على طريق الهداية 💚',
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'التذكير اليومي',
          channelDescription: 'تذكير يومي للتحفيز',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> sendEmergencyNotification() async {
    await _plugin.show(
      1,
      '🛑 وقفة — تذكّر',
      'هذا إغراء مؤقت. افتح التطبيق للمساعدة',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'emergency',
          'تنبيه الطوارئ',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
    );
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}
