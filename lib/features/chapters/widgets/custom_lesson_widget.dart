import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/chapters/widgets/custom_check_mark.dart';
import 'package:tayssir/features/units/widgets/animated_circular_progress_widget.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

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
    final user = ref.watch(userNotifierProvider).valueOrNull;
    final isSub = user?.isSub ?? false;
    final bool isLocked = onPressed == null;

    IconData getLessonIcon() {
      if (isLocked) return Icons.lock_rounded;
      if (progress >= 100) return Icons.check_circle_rounded;
      if (progress > 0) return Icons.timelapse_rounded;
      return Icons.play_arrow_rounded;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      // dynamic height to support multiple lines
      constraints: BoxConstraints(minHeight: 84.h),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Progress Avatar (RIGHT side in RTL)
            AnimatedCircularProgressWidget(
              percentage: progress,
              color: const Color(0xffEC4899),
              imageUrl: imageUrl,
              size: 80,
              borderWidth: 5.0,
              padding: 5.0,
              isLocked: isLocked,
            ),

            12.horizontalSpace,

            // 2. Text Information Card (LEFT side in RTL)
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 50.h),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: isLocked
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xff00B4D8), Color(0xff0077B6)],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                  color: isLocked 
                      ? (Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF1E293B) 
                          : const Color(0xffF1F5F9)) 
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isLocked 
                          ? Colors.black.withOpacity(0.04)
                          : const Color(0xff00B4D8).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if (isPremium && !isSub) {
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
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Lesson Title (Starts at Right inside card)
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: isLocked 
                                  ? (Theme.of(context).brightness == Brightness.dark 
                                      ? const Color(0xFF94A3B8) 
                                      : const Color(0xff64748B))
                                  : Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SomarSans',
                              height: 1.15,
                            ),
                          ),
                        ),
                        
                        12.horizontalSpace,

                        // Action Icon (Ends at Left inside the card)
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: isLocked 
                                ? (Theme.of(context).brightness == Brightness.dark 
                                    ? const Color(0xFF334155) 
                                    : const Color(0xffCBD5E0).withOpacity(0.5))
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            getLessonIcon(),
                            color: isLocked 
                                ? (Theme.of(context).brightness == Brightness.dark 
                                    ? const Color(0xFF64748B) 
                                    : const Color(0xff64748B))
                                : Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    ));
  }
}
