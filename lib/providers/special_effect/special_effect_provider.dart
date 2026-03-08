import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/settings/settings_provider.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';

final isSoundEnabledProvider = StateProvider<bool>((ref) {
  final isSoundEnabled = ref.watch(settingsNotifierProvider).isSoundEnabled;
  return isSoundEnabled;
});

final specialEffectServiceProvider = Provider<SpecialEffectService>((ref) {
  final isSoundEnabled = ref.watch(isSoundEnabledProvider);
  return SpecialEffectService(isSoundEnabled: isSoundEnabled);
});

class SpecialEffectService {
  final bool isSoundEnabled;

  SpecialEffectService({required this.isSoundEnabled});

  Future<void> playEffects({
    bool shouldPlaySound = true,
    bool shouldVibrate = true,
  }) async {
    if (isSoundEnabled) {
      SoundService.playClickPremium();
      return;
    }
  }
}
