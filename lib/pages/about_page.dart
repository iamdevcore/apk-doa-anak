import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int dailyTarget = 3;
  int doaHariIni = 0;

  // 🔔 PENGINGAT (BARU)
  bool reminderEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadReminder();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doaHariIni = prefs.getInt('daily_read') ?? 0;
    });
  }

  // 🔔 LOAD STATUS PENGINGAT
  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reminderEnabled = prefs.getBool('reminder_enabled') ?? true;
    });
  }

  // 🏆 BADGE
  String get badge {
    if (doaHariIni >= 10) return '🏆 Hebat';
    if (doaHariIni >= 5) return '🌟 Rajin';
    return '🌱 Pemula';
  }

  @override
  Widget build(BuildContext context) {
    final progress = doaHariIni / dailyTarget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 🔹 INFO APLIKASI (LAMA)
          _card(
            title: '📘 Doa Anak-Anak',
            child: const Text(
              'Aplikasi edukasi untuk membantu anak-anak belajar doa harian '
              'dengan tampilan ramah anak dan audio pendukung.',
            ),
          ),

          /// 🔹 DAILY TARGET (LAMA)
          _card(
            title: '🎯 Target Harian Anak',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Target: $dailyTarget doa / hari'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 6),
                Text('Dibaca hari ini: $doaHariIni'),
              ],
            ),
          ),

          /// 🔹 BADGE ANAK (LAMA)
          _card(
            title: '🏆 Badge Anak',
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 30),
                const SizedBox(width: 12),
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 🔔 PENGINGAT DOA (BARU – ON/OFF)
          _card(
            title: '🔔 Pengingat Doa',
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aktifkan Pengingat Harian'),
              value: reminderEnabled,
              onChanged: (v) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('reminder_enabled', v);
                setState(() => reminderEnabled = v);
              },
            ),
          ),

          /// 🔹 PARENT INFO (LAMA)
          _expandableCard(
            title: '👨‍👩‍👧 Tips untuk Orang Tua',
            children: const [
              Text('• Dampingi anak saat membaca doa'),
              SizedBox(height: 6),
              Text('• Putar audio doa bersama anak'),
              SizedBox(height: 6),
              Text('• Biasakan doa sebelum tidur & makan'),
            ],
          ),

          /// 🔹 INFO TEKNIS (LAMA)
          _card(
            title: '⚙️ Informasi Aplikasi',
            child: const Text(
              'Versi: 1.0.0\n'
              'Dibuat dengan Flutter & Firebase\n'
              'Kategori: Edukasi Anak',
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 CARD
  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  /// 🔹 EXPANDABLE CARD
  Widget _expandableCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
