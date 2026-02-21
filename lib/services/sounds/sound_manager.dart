import 'package:just_audio/just_audio.dart';
import 'package:tayssir/debug/app_logger.dart';

// maybe concvert to a provider
class SoundService {
  // singletoon
  static final SoundService _instance = SoundService._internal();

  factory SoundService() => _instance;

  SoundService._internal() {
    // player.setAsset('assets/sounds/ms_click.mp3');
    // player.setLoopMode(LoopMode.one);
  }

  static void playSound() async {
    try {
      // if (_instance.player.playing) {
      //   await _instance.player.stop();
      //   return;
      // }
      // // player.
      // await _instance.player.play();

      final player = AudioPlayer();
      player.setAsset('assets/sounds/ms_click.mp3');
      await player.setVolume(0.5);
      await player.play();
    } catch (e) {
      AppLogger.logError('Error playing sound$e');
    }
  }
}
