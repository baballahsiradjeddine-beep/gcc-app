import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ReviewAIPopup extends ConsumerWidget {
  final int count;
  final bool isDebug;

  const ReviewAIPopup({super.key, required this.count, this.isDebug = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(24.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.9),
            borderRadius: BorderRadius.circular(35.r),
            border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B4D8).withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AI Icon with pulse
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "🤖",
                  style: TextStyle(fontSize: 45.sp),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.5.seconds, curve: Curves.easeInOut),
              
              20.verticalSpace,
              
              Text(
                "تحليل الذكاء الاصطناعي جاهز! 🚀",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              
              12.verticalSpace,
              
              Text(
                "تيتو قام بتحليل أخطائك السابقة وحضر لك $count أسئلة ذكية لتقوية نقاط ضعفك الآن. هل أنت مستعد للتحدي؟",
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 15.sp,
                  fontFamily: 'SomarSans',
                  height: 1.5,
                ),
              ),
              
              30.verticalSpace,
              
              Row(
                children: [
                  Expanded(
                    child: _Button(
                      text: "ليس الآن",
                      isPrimary: false,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  12.horizontalSpace,
                    Expanded(
                    child: _Button(
                      text: "ابدأ المراجعة",
                      isPrimary: true,
                      onPressed: () {
                        Navigator.pop(context);
                        if (isDebug) {
                          ref.read(isReviewProvider.notifier).state = true;
                          ref.read(isDebugReviewProvider.notifier).state = true;
                        } else {
                          ref.read(isReviewProvider.notifier).state = true;
                          ref.read(isDebugReviewProvider.notifier).state = false;
                        }
                        context.pushNamed(AppRoutes.exercices.name);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack, duration: 500.ms).fadeIn(),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _Button({required this.text, required this.isPrimary, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF00B4D8) : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
          border: isPrimary ? null : Border.all(color: const Color(0xFF334155)),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: const Color(0xFF00B4D8).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ] : null,
        ),
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
    );
  }
}
