import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _key = 'read_doa';

  static Future<void> markRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (!list.contains(id)) {
      list.add(id);
      await prefs.setStringList(_key, list);
    }
  }

  static Future<double> progress(int total) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return total == 0 ? 0 : list.length / total;
  }
}
