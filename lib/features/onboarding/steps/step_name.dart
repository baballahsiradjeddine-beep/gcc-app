import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/features/onboarding/widgets/onboarding_button.dart';
import 'package:tayssir/features/onboarding/widgets/tito_speaker.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:flutter/services.dart';

class StepNamePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const StepNamePage({super.key, required this.onNext});

  @override
  ConsumerState<StepNamePage> createState() => _StepNamePageState();
}

class _StepNamePageState extends ConsumerState<StepNamePage> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (!_hasText) return;
    final isSoundOn = ref.read(isSoundEnabledProvider);
    if (isSoundOn) {
      SoundService.play('assets/sounds/success_short.mp3');
      HapticFeedback.mediumImpact();
    }
    await ref.read(onboardingProvider.notifier).setName(_controller.text.trim());
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              60.verticalSpace,

              // ── Tito + Bubble ──
              TitoSpeaker(
                message: 'مرحباً! 👋\nأنا تيتو مساعدك الذكي!\nبماذا ينادونك أصدقاؤك؟',
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack),

              40.verticalSpace,

              // ── Name Input ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'اسمك',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 14.sp,
                      fontFamily: 'SomarSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.verticalSpace,
                  _NameTextField(controller: _controller),
                ],
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

              32.verticalSpace,

              // ── Hint ──
              Text(
                'سيخاطبك تيتو باسمك طوال رحلة التعلم 🌟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 13.sp,
                  fontFamily: 'SomarSans',
                ),
              ).animate().fadeIn(delay: 500.ms),

              const Spacer(),

              // ── CTA Button ──
              OnboardingButton(
                label: 'متابعة →',
                enabled: _hasText,
                onPressed: _handleNext,
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.4, end: 0),

              12.verticalSpace,

              // ── Already have an account? ──
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.login.name),
                child: Text(
                  'لدي حساب سابق',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 15.sp,
                    fontFamily: 'SomarSans',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF94A3B8).withOpacity(0.3),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),

              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  final TextEditingController controller;
  const _NameTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontFamily: 'SomarSans',
          fontWeight: FontWeight.w900,
        ),
        decoration: InputDecoration(
          hintText: 'مثال: أحمد',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 20.sp,
            fontFamily: 'SomarSans',
          ),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
        ),
        onSubmitted: (_) {},
      ),
    );
  }
}
