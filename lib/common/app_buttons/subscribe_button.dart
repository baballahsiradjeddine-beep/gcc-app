import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';

import '../../router/app_router.dart';
import 'app_button.dart';

class SubscribeButton extends ConsumerWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).value;
    handlePress() {
      if (user != null && !user.isSub) {
        context.pushNamed(AppRoutes.subscriptionOptions.name);
        return;
      }
    }

    return Container(
      width: double.infinity,
      height: 120.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF387CA6),
        borderRadius: BorderRadius.circular(32.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Dot Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                painter: DotPatternPainter(),
              ),
            ),
          ),
          
          // Background Glow
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.12), Colors.transparent],
                ),
              ),
            ),
          ),

          // Dolphin Character (Left)
          Positioned(
            left: -10.w,
            top: 0,
            bottom: 0,
            width: 130.w,
            child: Center(
              child: SizedBox(
                width: 105.w,
                height: 105.h,
                child: const DynamicAppAsset(
                  assetKey: 'subscribe_banner',
                  fallbackAssetPath: SVGs.titoBoarding,
                  type: AppAssetType.svg,
                ),
              ),
            ),
          ),

          // Content (Right)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 220.w,
              padding: EdgeInsets.only(right: 15.w, left: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'احصل على جميع الدورات والمحتويات المميزة الآن!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp, // Adjusted
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                      height: 1.1,
                    ),
                  ),
                  7.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      final email = ref.watch(userNotifierProvider).value?.email;
                      AppLogger.sendLog(
                        email: email ?? '',
                        content: 'Clicked on subscribe button',
                        type: LogType.subscriptions,
                      );
                      handlePress();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h), // Balanced padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Text(
                        'اشترك الآن',
                        style: TextStyle(
                          color: const Color(0xFF387CA6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 1500.ms,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 18.0;
    const radius = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
