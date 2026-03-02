import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/features/onboarding/widgets/onboarding_button.dart';
import 'package:tayssir/features/onboarding/widgets/tito_speaker.dart';

// ─── A sample demo question model ───
class _DemoChoice {
  final String text;
  final bool isCorrect;
  const _DemoChoice({required this.text, required this.isCorrect});
}

const _demoQuestion = 'أي من التالي يُعبّر عن قانون نيوتن الثاني؟';
const _demoChoices = [
  _DemoChoice(text: 'F = m × a', isCorrect: true),
  _DemoChoice(text: 'E = mc²', isCorrect: false),
  _DemoChoice(text: 'P = m × v', isCorrect: false),
  _DemoChoice(text: 'W = F × d', isCorrect: false),
];

class StepDemoExercisePage extends ConsumerStatefulWidget {
  final Future<void> Function() onRegister;
  final VoidCallback onSkip;

  const StepDemoExercisePage({
    super.key,
    required this.onRegister,
    required this.onSkip,
  });

  @override
  ConsumerState<StepDemoExercisePage> createState() =>
      _StepDemoExercisePageState();
}

class _StepDemoExercisePageState extends ConsumerState<StepDemoExercisePage>
    with TickerProviderStateMixin {
  int? _selectedIndex;
  bool _isAnswered = false;
  bool _showResult = false;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showResult = true);
      if (_demoChoices[index].isCorrect) {
        _celebrationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(onboardingProvider).name ?? 'صديقي';
    final isCorrect =
        _selectedIndex != null && _demoChoices[_selectedIndex!].isCorrect;

    if (_showResult) {
      return _ResultView(
        name: name,
        isCorrect: isCorrect,
        controller: _celebrationController,
        onRegister: widget.onRegister,
        onSkip: widget.onSkip,
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            52.verticalSpace,

            // ── Tito prompt ──
            TitoSpeaker(
              message: 'الآن جرّب حل سؤال حقيقي! 🧠\nلا تقلق، هذا مجرد تجربة',
            ).animate().fadeIn(duration: 400.ms),

            28.verticalSpace,

            // ── Question Card ──
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                _demoQuestion,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

            20.verticalSpace,

            // ── Choices ──
            Expanded(
              child: ListView.builder(
                itemCount: _demoChoices.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  return _ChoiceTile(
                    choice: _demoChoices[i],
                    index: i,
                    selectedIndex: _selectedIndex,
                    isAnswered: _isAnswered,
                    onTap: () => _selectAnswer(i),
                  );
                },
              ),
            ),

            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

// ─────────────── Choice Tile ───────────────

class _ChoiceTile extends StatelessWidget {
  final _DemoChoice choice;
  final int index;
  final int? selectedIndex;
  final bool isAnswered;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.choice,
    required this.index,
    required this.selectedIndex,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final showCorrect = isAnswered && choice.isCorrect;
    final showWrong = isAnswered && isSelected && !choice.isCorrect;

    Color borderColor = const Color(0xFF334155);
    Color bgColor = const Color(0xFF1E293B);
    Color textColor = const Color(0xFF94A3B8);
    IconData? icon;

    if (showCorrect) {
      borderColor = const Color(0xFF10B981);
      bgColor = const Color(0xFF10B981).withOpacity(0.12);
      textColor = const Color(0xFF10B981);
      icon = Icons.check_circle_rounded;
    } else if (showWrong) {
      borderColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFEF4444).withOpacity(0.10);
      textColor = const Color(0xFFEF4444);
      icon = Icons.cancel_rounded;
    } else if (isSelected) {
      borderColor = const Color(0xFF00B4D8);
      bgColor = const Color(0xFF00B4D8).withOpacity(0.10);
      textColor = const Color(0xFF00B4D8);
    }

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: (showCorrect || showWrong)
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(icon, color: borderColor, size: 22.sp)
            else
              SizedBox(width: 22.sp),
            Expanded(
              child: Text(
                choice.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
            ),
            SizedBox(width: 22.sp),
          ],
        ),
      ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1, end: 0),
    );
  }
}

// ─────────────── Result View ───────────────

class _ResultView extends StatelessWidget {
  final String name;
  final bool isCorrect;
  final AnimationController controller;
  final Future<void> Function() onRegister;
  final VoidCallback onSkip;

  const _ResultView({
    required this.name,
    required this.isCorrect,
    required this.controller,
    required this.onRegister,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          children: [
            52.verticalSpace,

            // ── Result emoji ──
            Text(
              isCorrect ? '🎉' : '💪',
              style: TextStyle(fontSize: 90.sp),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -8, end: 8, duration: 2.seconds, curve: Curves.easeInOutSine)
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            32.verticalSpace,

            // ── Message ──
            Text(
              isCorrect
                  ? 'ممتاز يا $name! 🌟\nأجبت بشكل صحيح في أول محاولة!'
                  : 'أحسنت يا $name! 💪\nالتعلم رحلة وستصبح أفضل!',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

            24.verticalSpace,

            // ── CTA block ──
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00B4D8).withOpacity(0.12),
                    const Color(0xFFEC4899).withOpacity(0.08),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  Text(
                    'سجّل الآن لتحفظ\nمسارك ونقاطك! 🚀',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                      height: 1.5,
                    ),
                  ),
                  20.verticalSpace,
                  OnboardingButton(
                    label: '🔑 إنشاء حساب مجاناً',
                    enabled: true,
                    onPressed: onRegister,
                    color: const Color(0xFF00B4D8),
                  ),
                  12.verticalSpace,
                  GestureDetector(
                    onTap: onSkip,
                    child: Text(
                      'تخطي الآن',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontFamily: 'SomarSans',
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
