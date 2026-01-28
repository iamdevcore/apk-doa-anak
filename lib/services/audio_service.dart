import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play(String asset) async {
    await _player.stop();
    await _player.play(AssetSource(asset));
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
