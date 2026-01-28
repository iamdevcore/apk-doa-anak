import 'package:shared_preferences/shared_preferences.dart';

class DailyResetService {
  static const _lastDateKey = 'last_open_date';
  static const _progressKey = 'daily_progress';

  static Future<void> checkAndReset() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_lastDateKey);

    if (lastDate != today) {
      await prefs.setInt(_progressKey, 0); // reset target
      await prefs.setString(_lastDateKey, today);
    }
  }
}
