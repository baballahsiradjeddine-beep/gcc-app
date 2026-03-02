import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/steps/step_tour.dart';

/// The big animated card in the tour step
class TourSpotlightCard extends StatelessWidget {
  final TourStep step;
  final String titoMessage;
  final int stepIndex;
  final int totalSteps;
  final AnimationController pulseController;

  const TourSpotlightCard({
    super.key,
    required this.step,
    required this.titoMessage,
    required this.stepIndex,
    required this.totalSteps,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        color: const Color(0xFF1E293B),
        border: Border.all(color: step.color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: step.color.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Big pulsing icon ──
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final scale = 1.0 + pulseController.value * 0.06;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    step.color.withOpacity(0.25),
                    step.color.withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: step.color.withOpacity(0.5), width: 2),
              ),
              child: Icon(
                step.icon,
                color: step.color,
                size: 52.sp,
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

          28.verticalSpace,

          // ── Section Label ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: step.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: step.color.withOpacity(0.3)),
            ),
            child: Text(
              _sectionLabel(step.highlight),
              style: TextStyle(
                color: step.color,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SomarSans',
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),

          20.verticalSpace,

          // ── Tito message ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              titoMessage,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SomarSans',
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
          ),

          24.verticalSpace,

          // ── Step counter ──
          Text(
            '${stepIndex + 1} / $totalSteps',
            style: TextStyle(
              color: const Color(0xFF475569),
              fontSize: 13.sp,
              fontFamily: 'SomarSans',
            ),
          ),
        ],
      ),
    );
  }

  String _sectionLabel(String highlight) {
    switch (highlight) {
      case 'tools':
        return '🧰 صفحة الأدوات';
      case 'challenges':
        return '🎮 صفحة التحديات';
      case 'leaderboard':
        return '🏆 لوحة المتصدرين';
      case 'streaks':
        return '🔥 سلاسل التعلم';
      case 'home':
        return '📚 الصفحة الرئيسية';
      default:
        return highlight;
    }
  }
}
