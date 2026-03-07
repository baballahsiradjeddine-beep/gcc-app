import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:flutter/services.dart';
import 'tito_bubble_talk_widget.dart';
import '../utils/enums/triangle_side.dart';

class TitoAdviceWidget extends HookConsumerWidget {
  const TitoAdviceWidget({
    super.key,
    required this.text,
    this.isHorizontal = true,
    this.size,
  });

  final String text;
  final double? size;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    
    useEffect(() {
      if (isSoundOn) {
        SoundService.playAiMagic();
      }
      return null;
    }, []);

    if (isHorizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TitoBubbleTalkWidget(
              text: text,
              triangleSide: TriangleSide.left,
            ),
          ),
          8.horizontalSpace,
          _buildTito(40.sp, isSoundOn),
        ],
      );
    } else {
      return Column(
        children: [
          TitoBubbleTalkWidget(
            text: text,
            triangleSide: TriangleSide.bottom,
          ),
          8.verticalSpace,
          _buildTito(60.sp, isSoundOn),
        ],
      );
    }
  }

  Widget _buildTito(double emojiSize, bool isSoundOn) {
    return GestureDetector(
      onTap: () {
        if (isSoundOn) {
          SoundService.playClickPremium();
          HapticFeedback.lightImpact();
        }
      },
      child: Text(
        "🐬",
        style: TextStyle(fontSize: emojiSize),
      )
      .animate(onPlay: (controller) => controller.repeat())
      .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOutSine),
    );
  }
}
