import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/steps/step_division.dart';
import 'package:tayssir/features/onboarding/steps/step_name.dart';
import 'package:tayssir/features/onboarding/steps/step_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  static const _totalPages = 3; // name + division + theme

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _nextPage() => _goToPage(_currentPage + 1);

  /// Called after division is selected.
  /// The router automatically redirects to /home via routes_service
  /// when isReadyForTour becomes true — no manual navigation needed.
  Future<void> _launchTour() async {
    // Navigation is handled by routes_service refreshable listener
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Stack(
        children: [
          _BackgroundDecor(),

          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StepNamePage(onNext: _nextPage),
              StepDivisionPage(onNext: _nextPage),
              StepThemePage(onNext: _launchTour),
            ],
          ),

          // Progress dots
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.h,
            left: 0,
            right: 0,
            child: _ProgressDots(current: _currentPage, total: _totalPages),
          ),
        ],
      ),
    );
  }
}

// ── Background ──────────────────────────────

class _BackgroundDecor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80.h,
          right: -80.w,
          child: Container(
            width: 280.w,
            height: 280.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF00B4D8).withOpacity(0.18),
                Colors.transparent,
              ]),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 4.seconds),
        ),
        Positioned(
          bottom: -60.h,
          left: -60.w,
          child: Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFEC4899).withOpacity(0.14),
                Colors.transparent,
              ]),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 3.5.seconds),
        ),
      ],
    );
  }
}

// ── Progress Dots ────────────────────────────

class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 28.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF00B4D8)
                : const Color(0xFF00B4D8).withOpacity(0.25),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
