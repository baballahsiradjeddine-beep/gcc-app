import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_bubble_talk_widget.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodor_status_x.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_controller.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_state.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_status.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';

class PomodoroScreen extends HookConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PomodoroState>(pomodoroControllerProvider, (prev, next) {
      if (next.status == PomodoroStatus.stopped && prev?.status != PomodoroStatus.stopped) {
        DialogService.showPomodoroDoneDialog(context, () {
          ref.read(pomodoroControllerProvider.notifier).reset();
        });
      }
    });

    final state = ref.watch(pomodoroControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    String getTime() {
      final minutes = (state.remainingTime ~/ 60).toString().padLeft(2, '0');
      final seconds = (state.remainingTime % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }

    return AppScaffold(
      paddingB: 0,
      topSafeArea: true,
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                    children: [
                      TextSpan(
                        text: "Tay",
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
                      ),
                      const TextSpan(
                        text: "ssir",
                        style: TextStyle(color: Color(0xFF00B4D8)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Logic for theme toggle if needed here, but usually handled by global settings
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: isDark ? Colors.yellow : const Color(0xFF64748B),
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          Expanded(
            child: SliverScrollingWidget(
              children: [
                20.verticalSpace,
                
                // Tito Advice Bubble
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 280.w),
                    child: TitoBubbleTalkWidget(
                      text: state.status.adviceText.replaceAll(' ', '\n'), // Matches the multiline break in HTML
                      triangleSide: TriangleSide.bottom,
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
                
                40.verticalSpace,
                
                // Circular Timer and Dolphin
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Progress (Custom Painter for exact control)
                      SizedBox(
                        width: 256.r,
                        height: 256.r,
                        child: CustomPaint(
                          painter: PomodoroCirclePainter(
                            progress: state.progress,
                            isDark: isDark,
                          ),
                        ),
                      ),
                      
                      // Dolphin Character
                      Positioned(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "🐬",
                              style: TextStyle(
                                fontSize: 100.sp,
                                color: (state.status == PomodoroStatus.paused || state.status == PomodoroStatus.stopped) 
                                    ? Colors.grey 
                                    : null,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 10),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                            ).animate(onPlay: (c) => c.repeat(reverse: true))
                             .moveY(begin: -8, end: 8, duration: 4.seconds, curve: Curves.easeInOut)
                             .rotate(begin: -0.04, end: 0.04, duration: 4.seconds, curve: Curves.easeInOut),
                            
                            // Alarm Emoji
                            Positioned(
                              left: -10.w,
                              bottom: 20.h,
                              child: Text(
                                state.status == PomodoroStatus.running ? "⏰" : "⏱️",
                                style: TextStyle(fontSize: 40.sp),
                              ).animate(onPlay: (c) => c.repeat(reverse: true))
                               .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut),
                            ),
                            
                            // Sparkles
                            if (state.status == PomodoroStatus.running)
                              ...[
                                Positioned(
                                  top: 10.h,
                                  right: -10.w,
                                  child: Text("✨", style: TextStyle(fontSize: 20.sp, color: const Color(0xFF00B4D8)))
                                    .animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 2.seconds),
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  left: 10.w,
                                  child: Text("✨", style: TextStyle(fontSize: 18.sp, color: const Color(0xFF0077B6)))
                                    .animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 2.seconds),
                                ),
                              ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
                
                24.verticalSpace,
                
                // Digital Time
                Center(
                  child: Text(
                    getTime(),
                    style: TextStyle(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00B4D8),
                      fontFamily: 'SomarSans',
                      letterSpacing: 4,
                      shadows: [Shadow(color: const Color(0xFF00B4D8).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms).scale(),
                
                32.verticalSpace,
                
                // Main Action Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: GestureDetector(
                    onTap: () {
                      if (state.isRunning) {
                        ref.read(pomodoroControllerProvider.notifier).pause();
                      } else {
                        ref.read(pomodoroControllerProvider.notifier).start();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        gradient: state.isRunning 
                            ? null 
                            : const LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF0077B6)]),
                        color: state.isRunning 
                            ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)) 
                            : null,
                        borderRadius: BorderRadius.circular(20.r),
                        border: state.isRunning ? Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)) : null,
                        boxShadow: state.isRunning ? [] : [
                          BoxShadow(
                            color: const Color(0xFF00B4D8).withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          state.isRunning ? "إيقاف" : (state.remainingTime < state.totalTime ? "أكمل" : "إبدأ"),
                          style: TextStyle(
                            color: state.isRunning ? (isDark ? Colors.white : const Color(0xFF1E293B)) : Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ),
                    ).animate(target: state.isRunning ? 0 : 1)
                     .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 200.ms),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
                
                if (state.canReset)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => ref.read(pomodoroControllerProvider.notifier).reset(),
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            boxShadow: [
                               BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                            ]
                          ),
                          child: Icon(Icons.refresh_rounded, color: const Color(0xFF00B4D8), size: 28.sp),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                
                80.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PomodoroCirclePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  PomodoroCirclePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    
    // Background Circle
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // In HTML, it goes clockwise. 0% is top (-90 degrees).
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Knob (Indicator Circle)
    final knobOffset = Offset(
      center.dx + radius * math.cos(-math.pi / 2 + 2 * math.pi * progress),
      center.dy + radius * math.sin(-math.pi / 2 + 2 * math.pi * progress),
    );

    final knobPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final knobBorderPaint = Paint()
      ..color = const Color(0xFF00B4D8)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(knobOffset, 11, knobPaint);
    canvas.drawCircle(knobOffset, 11, knobBorderPaint);
    
    // Glow for knob
    final glowPaint = Paint()
      ..color = const Color(0xFF00B4D8).withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(knobOffset, 11, glowPaint);
  }

  @override
  bool shouldRepaint(covariant PomodoroCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
