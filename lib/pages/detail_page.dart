import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/badge_auto_service.dart';

class DetailPage extends StatefulWidget {
  final QueryDocumentSnapshot data;
  final bool kidMode;

  const DetailPage({
    super.key,
    required this.data,
    required this.kidMode,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  // ⭐ FAVORITE
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.data.id) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    await prefs.setBool(widget.data.id, isFavorite);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Ditambahkan ke Favorit ⭐'
              : 'Dihapus dari Favorit',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

 // 🔊 AUDIO + DAILY TARGET
Future<void> playAudio() async {
  final audio = widget.data['audio'];
  final prefs = await SharedPreferences.getInstance();

  if (isPlaying) {
    await _player.stop();
    setState(() => isPlaying = false);
  } else {
    await _player.play(AssetSource('audio/$audio'));

    // ✅ SUDAH ADA (punya kamu)
    prefs.setInt(
      'total_read',
      (prefs.getInt('total_read') ?? 0) + 1,
    );

    // ✅ TAMBAHAN BARU (AUTO BADGE)
    await BadgeAutoService.addReadCount();

    setState(() => isPlaying = true);
  }
}

  @override
  Widget build(BuildContext context) {
    final fontArab = widget.kidMode ? 28.0 : 24.0;
    final fontLatin = widget.kidMode ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['judul']),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade100,
                    Colors.green.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.data['arab'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontArab,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.data['latin'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontLatin),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.data['arti'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 28),

                    // 🔊 AUDIO BUTTON (TETAP ADA)
                    ElevatedButton.icon(
                      onPressed: playAudio,
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.volume_up,
                      ),
                      label: Text(
                        isPlaying ? 'Hentikan Doa' : 'Putar Doa',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
