import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_logo.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/features/splash/splash_screen.dart';
import 'package:tayssir/providers/auth/auth_notifier.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import '../../../../../common/app_buttons/big_button.dart';
import '../../../../../common/core/app_scaffold.dart';
import '../../../../../constants/strings.dart';
import '../../../../../common/tito_bubble_talk_widget.dart';
import '../../../../../utils/enums/triangle_side.dart';

class RegisterSuccessfullView extends ConsumerWidget {
  const RegisterSuccessfullView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(registerControllerProvider.select((v) => v.value), (prev, next) {
      next.handleSideThings(context, () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          SnackBarService.showSuccessSnackBar(
            'لقد قمت بإنشاء حسابك بنجاح',
            context: context,
          );
        });
      });
    });

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      body: Stack(
        children: [
          // Background Decorative Blobs
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0077B6).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SliverScrollingWidget(
            children: [
              60.verticalSpace,
              
              // App Logo
              const AppLogo(fontSize: 45)
                  .animate().fadeIn(duration: 600.ms).scale(curve: Curves.easeOutBack),
              
              60.verticalSpace,
              
              // Bubble + Dolphin (from HTML successView)
              Column(
                children: [
                  TitoBubbleTalkWidget(
                    text: "أحسنت تمت عملية التسجيل",
                    triangleSide: TriangleSide.bottom,
                  ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.elasticOut),
                  
                  12.verticalSpace,
                  
                  // Dolphin with sparkles
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        "🐬",
                        style: TextStyle(fontSize: 130.sp),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .moveY(begin: -8, end: 8, duration: 4.seconds, curve: Curves.easeInOutSine)
                       .rotate(begin: -0.04, end: 0.04, duration: 4.seconds, curve: Curves.easeInOutSine),
                      
                      Positioned(
                        top: 0,
                        right: -10.w,
                        child: Text("✨", style: TextStyle(fontSize: 24.sp, color: const Color(0xFF00B4D8)))
                            .animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 2.seconds),
                      ),
                      Positioned(
                        top: 40.h,
                        right: -20.w,
                        child: Text("⭐", style: TextStyle(fontSize: 20.sp, color: const Color(0xFFF43F5E)))
                            .animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1.0, 1.0), end: const Offset(1.4, 1.4), duration: 2.seconds),
                      ),
                      Positioned(
                        bottom: 30.h,
                        left: -10.w,
                        child: Text("✨", style: TextStyle(fontSize: 24.sp, color: const Color(0xFF0077B6)))
                            .animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.7, 0.7), end: const Offset(1.2, 1.2), duration: 2.seconds),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              
              32.verticalSpace,
              
              // Tito's welcome message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  AppStrings.titoTalk,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    fontFamily: 'SomarSans',
                    height: 1.6,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
              
              60.verticalSpace,
              
              BigButton(
                text: "إبدأ المغامرة",
                onPressed: ref.watch(registerControllerProvider).isLoading ||
                        ref.watch(authNotifierProvider).isLoading
                    ? null
                    : () {
                        ref.read(registerControllerProvider.notifier).fullRegister();
                      },
              ).animate().fadeIn(delay: 600.ms).scale(),
              
              if (ref.watch(authNotifierProvider).isLoading)
                Column(
                  children: [
                    24.verticalSpace,
                    const TayssirDataLoader(
                      textSize: 14,
                      iconSize: 32,
                    ),
                  ],
                ),
              
              60.verticalSpace,
            ],
          ),
        ],
      ),
    );
  }
}
