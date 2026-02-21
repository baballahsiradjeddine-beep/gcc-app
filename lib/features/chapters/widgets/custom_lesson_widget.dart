import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/features/chapters/widgets/custom_check_mark.dart';
import 'package:tayssir/features/units/widgets/animated_circular_progress_widget.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

//todo refector this to 2 seperate widgets , one for units and one for chapters and then all the nessesary changes done in here
class CustomLessonWidget extends ConsumerWidget {
  const CustomLessonWidget({
    super.key,
    required this.isCurrent,
    this.onPressed,
    required this.title,
    required this.progress,
    this.imageUrl,
    this.isPremium = false,
  });

  final String title;
  final bool isCurrent;
  final VoidCallback? onPressed;
  final double progress;
  final String? imageUrl;
  final bool isPremium;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = progress >= 50;
    final shouldShowMark =
        isCurrent || isComplete || onPressed == null || isPremium;
    final user = ref.watch(userNotifierProvider).requireValue!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedCircularProgressWidget(
            // isFull: progress > 0,
            color: isPremium ? const Color(0xffFFAF00) : AppColors.primaryColor,
            imageUrl: imageUrl,
            showPercentage: false,
            isLocked: onPressed == null || isPremium,
            percentage: isPremium ? 0 : progress,

            // child: const Icon(Icons.play_arrow),
          ),
          16.horizontalSpace,
          Expanded(
              child: PushableButton(
            height: 50.h,
            elevation: 4,
            onPressed: () {
              if (isPremium && !user.isSub) {
                DialogService.showNeedSubscriptionDialog(context);
                return;
              }
              if (onPressed != null) {
                ref.read(specialEffectServiceProvider).playEffects();
                onPressed!();
              } else {
                DialogService.showChapterLockedDialog(context);
              }
            },

            hslColor: HSLColor.fromColor(
              isPremium
                  ? const Color(0xffFFAF00)
                  : isCurrent || isComplete
                      ? AppColors.primaryColor
                      : Colors.white,
            ),
            hslDisabledColor: HSLColor.fromColor(const Color(0xffEEEEEE)),
            // hslDisabledColor: HSLColor.fromColor(),
            gradiantColors: isPremium
                ? [
                    const Color(0xffFF6F00),
                    const Color(0xffFFAF00),
                  ]
                : null,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 0.5.sw,
                    child: Text(title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: isPremium
                                ? Colors.white
                                : onPressed == null
                                    ? AppColors.disabledTextColor
                                    : isCurrent || isComplete
                                        ? Colors.white
                                        : const Color(0xff4B4B4B),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                  if (shouldShowMark) ...[
                    const Spacer(),
                    CustomCheckMark(
                        color: isPremium
                            ? const Color(0xffFFAF00)
                            : onPressed == null
                                ? AppColors.disabledTextColor
                                : AppColors.primaryColor,
                        icon: isPremium
                            ? Icons.star
                            : isCurrent
                                ? Icons.hourglass_bottom
                                : isComplete
                                    ? Icons.check
                                    : Icons.lock),
                  ]
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
