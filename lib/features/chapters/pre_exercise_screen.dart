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
          ),
          20.verticalSpace,
          Text(
            'يتم تحميل البيانات ... ${(progress * 100).toInt()}%',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff6F6F6F)),
          ),
          20.verticalSpace,
          Directionality(
            textDirection: TextDirection.rtl,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              minHeight: 15.h,
              borderRadius: BorderRadius.circular(20.r),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
          10.verticalSpace,
          Text(
            'استعد للنجاح! كل سؤال يقربك من تحقيق أحلامك.',
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff6F6F6F)),
          ),
        ],
      ),
    ));
  }
}
