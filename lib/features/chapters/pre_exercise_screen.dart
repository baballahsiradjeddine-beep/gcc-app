import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../resources/resources.dart';

class PreExerciseScreen extends HookConsumerWidget {
  const PreExerciseScreen({super.key, required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.isSmallDevice ? 270.h : 370.h;
    return AppScaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SVGs.icTitoProgress,
            height: size,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOutSine)
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
          20.verticalSpace,
          Text(
            'يتم تحميل البيانات ... ${(progress * 100).toInt()}%',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff6F6F6F),
                fontFamily: 'SomarSans'),
          ).animate().fadeIn(delay: 200.ms),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                minHeight: 12.h,
                borderRadius: BorderRadius.circular(20.r),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          15.verticalSpace,
          Text(
            'استعد للنجاح! كل سؤال يقربك من تحقيق أحلامك.',
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff94A3B8),
                fontFamily: 'SomarSans'),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    ));
  }
}
