import 'package:just_audio/just_audio.dart';
import 'package:tayssir/debug/app_logger.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  final AudioPlayer _player = AudioPlayer();

  factory SoundService() => _instance;

  SoundService._internal();

  static void play(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(assetPath);
      await player.setVolume(0.6);
      await player.play();
      // Dispose player after it finishes playing to free resources
      player.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (e) {
      AppLogger.logError('Error playing sound $assetPath: $e');
    }
  }

  static void playSuccess() => play('assets/sounds/success_short.mp3');
  static void playError() => play('assets/sounds/error_soft.mp3');
  static void playLevelComplete() => play('assets/sounds/level_complete.mp3');
  static void playStreak() => play('assets/sounds/streak_fire.mp3');
  static void playMatchFound() => play('assets/sounds/match_found.mp3');
  static void playChatPop() => play('assets/sounds/chat_pop.mp3');
  static void playPoints() => play('assets/sounds/points_collect.mp3');
  static void playAiMagic() => play('assets/sounds/ai_magic.mp3');
  static void playTaskDone() => play('assets/sounds/task_done.mp3');
  static void playClickPremium() => play('assets/sounds/ui_click_premium.mp3');
  static void playNotification() => play('assets/sounds/notification_ping.mp3');
  static void playAction() => play('assets/sounds/action.mp3');

  static void playDefaultClick() {
    play('assets/sounds/ui_click_premium.mp3');
  }
}
