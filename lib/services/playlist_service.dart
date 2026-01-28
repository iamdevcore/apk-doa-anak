import 'audio_service.dart';

class PlaylistService {
  static Future<void> playAll(List<String> audios) async {
    for (final a in audios) {
      await AudioService.play(a);
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}
