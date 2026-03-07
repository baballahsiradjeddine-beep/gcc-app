import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/constants/strings.dart';

import '../../common/app_buttons/big_button.dart';
import '../../resources/resources.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PomodoroDialogContent extends HookConsumerWidget {
  const PomodoroDialogContent({
    super.key,
    required this.onContinue,
  });
  final Function() onContinue;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    
    useEffect(() {
      if (isSoundOn) {
        SoundService.playTaskDone();
      }
      return null;
    }, []);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(24.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.8),
            borderRadius: BorderRadius.circular(35.r),
            border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "تمت الجلسة بنجاح! 🍅",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              20.verticalSpace,
              DynamicAppAsset(
                assetKey: 'tito_pomodoro_done',
                fallbackAssetPath: SVGs.titoPomodoroDone,
                type: AppAssetType.svg,
                height: 220.h,
              ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
              30.verticalSpace,
              Text(
                "لقد أنجزت وقتاً رائعاً من التركيز. خذ قسطاً من الراحة الآن!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 16.sp,
                  fontFamily: 'SomarSans',
                ),
              ),
              30.verticalSpace,
              BigButton(
                text: "استمرار",
                onPressed: () {
                  onContinue();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
      ),
    );
  }
}
