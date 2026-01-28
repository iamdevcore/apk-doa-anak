import 'package:shared_preferences/shared_preferences.dart';

class BadgeAutoService {
  /// Tambah hitungan doa dibaca
  static Future<void> addReadCount() async {
    final prefs = await SharedPreferences.getInstance();

    final total = prefs.getInt('total_read') ?? 0;
    await prefs.setInt('total_read', total + 1);
  }
}
