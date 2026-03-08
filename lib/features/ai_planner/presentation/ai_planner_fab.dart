import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../state/ai_planner_notifier.dart';
import 'ai_planner_popup.dart';

class AIPlannerFAB extends ConsumerWidget {
  const AIPlannerFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiPlannerProvider);
    
    // Hide if we have an active plan that isn't finished
    if (aiState.activePlan != null && !aiState.activePlan!.isFinished) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 100.h,
      left: 20.w,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AIPlannerPopup(),
          );
        },
        child: Container(
          width: 52.sp,
          height: 52.sp,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFF387CA6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF387CA6).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: Stack(
            children: [
              // 1. Dot Pattern Overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _DotPatternPainter(
                    color: Colors.white.withOpacity(0.22),
                    spacing: 8,
                  ),
                ),
              ),
              // 2. Glossy Shine
              Positioned(
                top: -15,
                left: -15,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // 3. Icon
              Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 2.seconds, curve: Curves.easeInOut)
            .shimmer(delay: 4.seconds, duration: 1.5.seconds),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  final Color color;
  final double spacing;

  _DotPatternPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        // Simple checkerboard shift for a more organic feel
        double x = i + ( ( (j / spacing).floor() % 2 == 0) ? 0 : spacing / 2);
        canvas.drawCircle(Offset(x, j), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
