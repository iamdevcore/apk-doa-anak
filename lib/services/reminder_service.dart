import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  /// WAJIB dipanggil SEKALI saat app start (di main.dart)
  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notif.initialize(settings);
  }

  /// 🔕 CEK apakah pengingat AKTIF / MATI
  static Future<bool> _isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('reminder_enabled') ?? true;
  }

  /// 🔔 Pengingat harian (AMAN + bisa ON/OFF)
  static Future<void> dailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final enabled = await _isEnabled();
    if (!enabled) return; // ❌ kalau dimatikan, tidak jadwalin

    final now = tz.TZDateTime.now(tz.local);
    var schedule = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (schedule.isBefore(now)) {
      schedule = schedule.add(const Duration(days: 1));
    }

    await _notif.zonedSchedule(
      id,
      title,
      body,
      schedule,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'doa_channel',
          'Pengingat Doa',
          channelDescription: 'Pengingat waktu doa anak',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 🔕 SET ON / OFF (dipakai di About / Parent)
  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', value);
  }

  /// ❌ HAPUS SEMUA pengingat
  static Future<void> cancelAll() async {
    await _notif.cancelAll();
  }
}
