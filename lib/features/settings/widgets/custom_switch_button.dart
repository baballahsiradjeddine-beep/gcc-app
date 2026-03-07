import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/settings/settings_provider.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:flutter/services.dart';

class CustomSwitchButton extends ConsumerWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
        activeTrackColor: AppColors.primaryColor,
        // inactiveTrackColor: Colors.grey[300],
        // trackOutlineWidth: WidgetStateProperty.all(0.0),
        // trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        // thumbColor: WidgetStateProperty.all(Colors.white),
        // overlayColor: WidgetStateProperty.all(Colors.transparent),
        // trackColor: WidgetStateProperty.all(Colors.transparent),

        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class AudioSoundSwitchButton extends ConsumerWidget {
  const AudioSoundSwitchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomSwitchButton(
        value: ref.watch(isSoundEnabledProvider),
        onChanged: (value) {
          final isSoundOn = ref.read(isSoundEnabledProvider);
          if (isSoundOn) {
            SoundService.play('assets/sounds/ui_click_premium.mp3');
            HapticFeedback.lightImpact();
          }
          ref.read(settingsNotifierProvider.notifier).toggleSound();
        },
      ),
    );
  }
}
