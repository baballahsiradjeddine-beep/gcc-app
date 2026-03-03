import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_logo.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/utils/extensions/context.dart';
import '../../../common/tito_bubble_talk_widget.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingB: 0.r,
      isScroll: false,
      topSafeArea: true,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            20.verticalSpace,
            // Logo Section
            const AppLogo(fontSize: 45)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
            
            40.verticalSpace,
            
            // Tito & Bubble Section
            Column(
              children: [
                const TitoBubbleTalkWidget(
                  text: "مرحبا أنا تيتو",
                  triangleSide: TriangleSide.bottom,
                ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.elasticOut),
                
                8.verticalSpace,
                
                Text(
                  "🐬",
                  style: TextStyle(fontSize: 120.sp),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .moveY(begin: -8, end: 8, duration: 2.seconds, curve: Curves.easeInOutSine),
              ],
            ),
            
            40.verticalSpace,
            
            // Welcome Description
            Text(
              "تعلم بسهولة مع تمارين تفاعلية ومراجعات شاملة مليئة بالمرح والتشويق ، في أي وقت وأينما كنت!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                fontFamily: 'SomarSans',
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            const Spacer(),
            
            // Action Buttons
            Column(
              children: [
                BigButton(
                  buttonType: ButtonType.primary,
                  text: "إبدأ الآن",
                  onPressed: () {
                    context.goNamed(AppRoutes.register.name);
                  },
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                
                16.verticalSpace,
                
                BigButton(
                  buttonType: ButtonType.secondary,
                  text: "لدي حساب بالفعل",
                  onPressed: () {
                    context.goNamed(AppRoutes.login.name);
                  },
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
            
            // 🧪 DEV ONLY: Reset onboarding
            if (kDebugMode)
            GestureDetector(
              onTap: () async {
                await ref.read(onboardingProvider.notifier).resetOnboarding();
                if (context.mounted) context.goNamed(AppRoutes.onboarding.name);
              },
              child: Text(
                '← تجربة شاشة الـ Onboarding (debug)',
                style: TextStyle(
                  color: const Color(0xFF334155),
                  fontSize: 11.sp,
                  fontFamily: 'SomarSans',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
