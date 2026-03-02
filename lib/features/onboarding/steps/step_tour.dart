import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/features/onboarding/widgets/onboarding_button.dart';
import 'package:tayssir/features/onboarding/widgets/tour_spotlight.dart';

/// Each step in the tour
class TourStep {
  final String titoMessage;
  final String highlight; // Which page/section to highlight
  final IconData icon;
  final Color color;

  const TourStep({
    required this.titoMessage,
    required this.highlight,
    required this.icon,
    required this.color,
  });
}

const _tourSteps = [
  TourStep(
    titoMessage: 'هذه صفحة الأدوات 🧰\nهنا ستجد مؤقت بومودورو،\nحاسبة النقاط، وبطاقات المراجعة!',
    highlight: 'tools',
    icon: Icons.construction_rounded,
    color: Color(0xFF06B6D4),
  ),
  TourStep(
    titoMessage: 'هنا صفحة التحديات 🎮\nتحدى أصحابك في منافسات\nمباشرة وحقق الفوز!',
    highlight: 'challenges',
    icon: Icons.sports_esports_rounded,
    color: Color(0xFF8B5CF6),
  ),
  TourStep(
    titoMessage: 'لوحة المتصدرين 🏆\nتنافس مع آلاف الطلاب\nوكن في القمة!',
    highlight: 'leaderboard',
    icon: Icons.leaderboard_rounded,
    color: Color(0xFFFFB800),
  ),
  TourStep(
    titoMessage: 'سلسلة التعلم اليومي 🔥\nحافظ على تعلمك كل يوم\nواحصل على مكافآت رائعة!',
    highlight: 'streaks',
    icon: Icons.local_fire_department_rounded,
    color: Color(0xFFF97316),
  ),
  TourStep(
    titoMessage: 'الصفحة الرئيسية 📚\nهنا تجد جميع موادك،\naختر مادة وابدأ التعلم الآن!',
    highlight: 'home',
    icon: Icons.home_rounded,
    color: Color(0xFF10B981),
  ),
];

class StepTourPage extends ConsumerStatefulWidget {
  final Future<void> Function() onFinish;
  const StepTourPage({super.key, required this.onFinish});

  @override
  ConsumerState<StepTourPage> createState() => _StepTourPageState();
}

class _StepTourPageState extends ConsumerState<StepTourPage>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _isFinishing = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _tourSteps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  Future<void> _handleFinish() async {
    setState(() => _isFinishing = true);
    await widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(onboardingProvider).name ?? 'صديقي';
    final step = _tourSteps[_currentStep];
    final isLast = _currentStep == _tourSteps.length - 1;

    return SafeArea(
      child: Column(
        children: [
          60.verticalSpace,

          // ── Step Header ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Text(
              'جولة سريعة في التطبيق',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 13.sp,
                fontFamily: 'SomarSans',
              ),
            ).animate().fadeIn(),
          ),

          16.verticalSpace,

          // ── Tour Spotlight Card ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.12), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: animation, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
                ),
                child: TourSpotlightCard(
                  key: ValueKey(_currentStep),
                  step: step,
                  titoMessage: _currentStep == 0
                      ? 'أهلاً يا $name! 🎉\n${step.titoMessage}'
                      : step.titoMessage,
                  stepIndex: _currentStep,
                  totalSteps: _tourSteps.length,
                  pulseController: _pulseController,
                ),
              ),
            ),
          ),

          28.verticalSpace,

          // ── Step dots ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_tourSteps.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: i == _currentStep ? 20.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: i == _currentStep
                      ? step.color
                      : step.color.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),

          24.verticalSpace,

          // ── CTA Buttons ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: isLast
                ? OnboardingButton(
                    label: '🚀 هيا نبدأ!',
                    enabled: !_isFinishing,
                    onPressed: _handleFinish,
                    color: const Color(0xFF10B981),
                  )
                : OnboardingButton(
                    label: 'التالي →',
                    enabled: true,
                    onPressed: _nextStep,
                    color: step.color,
                  ),
          ),

          32.verticalSpace,
        ],
      ),
    );
  }
}
