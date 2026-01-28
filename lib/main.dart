import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/home_page.dart';
import 'pages/favorite_page.dart';
import 'pages/about_page.dart';
import 'pages/badge_page.dart';
import 'services/reminder_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 AKTIFKAN PENGINGAT DEFAULT (TARUH DI SINI)
  await ReminderService.init();

ReminderService.dailyReminder(
  id: 1,
  hour: 5,
  minute: 30,
  title: '🌅 Doa Pagi',
  body: 'Ayo mulai hari dengan doa',
);

ReminderService.dailyReminder(
  id: 2,
  hour: 11,
  minute: 30,
  title: '🍽️ Doa Makan',
  body: 'Jangan lupa doa sebelum makan',
);

ReminderService.dailyReminder(
  id: 3,
  hour: 19,
  minute: 0,
  title: '🌙 Doa Tidur',
  body: 'Ayo baca doa sebelum tidur',
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final bool kidMode = true;

  late final List<Widget> pages = [
    HomePage(kidMode: kidMode),
    FavoritePage(kidMode: kidMode),
    const BadgePage(), // 🆕 MENU BARU
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events), // 🏆
            label: 'Badge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
