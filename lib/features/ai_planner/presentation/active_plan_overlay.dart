import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import '../state/ai_planner_notifier.dart';
import 'success_card.dart';

class ActivePlanOverlay extends ConsumerWidget {
  const ActivePlanOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(aiPlannerProvider);
    final plan = plannerState.activePlan;
    final isSoundOn = ref.watch(isSoundEnabledProvider);

    if (plan == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 20.h,
      left: 20.w,
      right: 20.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMinimizedPanel(context, ref, plan),
        ],
      ).animate().slideY(begin: 1.0, end: 0, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildMinimizedPanel(BuildContext context, WidgetRef ref, dynamic plan) {
    final double progress = plan.items.where((it) => it.isCompleted).length / plan.items.length;
    final bool isFinished = plan.isFinished;

    return GestureDetector(
      onTap: () => _showFullChecklist(context, ref, plan),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.8),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 45.sp,
                      height: 45.sp,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF00B4D8)),
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFinished ? "اكتملت الدراسة! 😍" : "خطة الدراسة الحالية ⚡",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                      Text(
                        isFinished ? "اضغط للمشاركة الآن" : "اضغط لمتابعة مهامك",
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12.sp,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isFinished ? Icons.celebration_rounded : Icons.keyboard_arrow_up_rounded,
                  color: const Color(0xFF00B4D8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFullChecklist(BuildContext context, WidgetRef ref, dynamic plan) {
    final isSoundOn = ref.read(isSoundEnabledProvider);
    if (plan.isFinished) {
       if (isSoundOn) SoundService.playAiMagic();
       showDialog(
         context: context,
         builder: (ctx) => SuccessCard(
           subjectName: plan.items.first.title.split(':').last.trim(),
           duration: plan.totalDurationMinutes >= 60 
            ? "${plan.totalDurationMinutes ~/ 60} ساعة"
            : "${plan.totalDurationMinutes} دقيقة",
           onShare: () {
             // Share logic
           },
           onClose: () {
             Navigator.pop(ctx);
             ref.read(aiPlannerProvider.notifier).resetPlan();
           },
         ),
       );
       return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: 0.8.sh,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
             Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
            ),
            25.verticalSpace,
            Text(
              "خطة الدراسة الذكية 🧠",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: plan.items.length,
                itemBuilder: (context, index) {
                  final item = plan.items[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: item.isCompleted ? const Color(0xFF00B4D8).withOpacity(0.05) : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: item.isCompleted ? const Color(0xFF00B4D8).withOpacity(0.5) : Colors.white10,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B4D8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            item.timeRange,
                            style: TextStyle(
                              color: const Color(0xFF00B4D8),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                item.description,
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: item.isCompleted,
                            onChanged: (_) {
                              if (isSoundOn) SoundService.playTaskDone();
                              ref.read(aiPlannerProvider.notifier).toggleItem(item.id);
                            },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                          activeColor: const Color(0xFF00B4D8),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
            
            BigButton(
              text: "إخفاء الخطة",
              onPressed: () => Navigator.pop(ctx),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const BigButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
      ),
    );
  }
}
