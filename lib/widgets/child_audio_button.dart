import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../data/doa_audio_map.dart';

class ChildAudioButton extends StatelessWidget {
  final String judul;

  const ChildAudioButton({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    final audio = doaAudio[judul.toLowerCase()];

    if (audio == null) return const SizedBox();

    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.volume_up),
      onPressed: () => AudioService.play(audio),
    );
  }
}
