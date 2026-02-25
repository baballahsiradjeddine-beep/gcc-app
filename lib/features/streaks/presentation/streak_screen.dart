import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/features/streaks/utils/streak_share_utils.dart';
import 'package:tayssir/router/app_router.dart';

class StreakScreen extends StatelessWidget {
  final StreakModel streak;
  final int unitId;

  const StreakScreen({super.key, required this.streak, required this.unitId});

  @override
  Widget build(BuildContext context) {
    final int currentStreak = streak.currentStreak;
    final int weekNumber = (currentStreak > 0) ? (currentStreak - 1) ~/ 7 : 0;
    final int weekStartDay = (weekNumber * 7) + 1;

    return AppScaffold(
      onPopScope: () {},
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            children: [
              // Header Section
              SizedBox(height: 5.h),
              Text(
                "مبارك لك 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "$currentStreak أيام متواصلة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),

              SizedBox(height: 10.h),

              // Responsive Fire Emoji
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB74D).withValues(alpha: 0.1),
                ),
                child: Text(
                  "🔥",
                  style: TextStyle(fontSize: 65.sp),
                ),
              ),

              SizedBox(height: 10.h),

              // Card Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Days Row - Numeric and RTL Correct
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final dayNumber = weekStartDay + index;
                          final bool isCompleted = dayNumber <= currentStreak;
                          return _buildNumericDayItem(dayNumber, isCompleted);
                        }),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1.2),
                    SizedBox(height: 8.h),
                    Text(
                      "سلسلتك تكبر مع كل يوم دراسي، لكن إذا توقفت ليوم واحد فقط، تبدأ من الصفر!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: const Color(0xFF1B365D),
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Footer Section
              Text(
                "لا تتوقف... كل يوم يصنع فارقاً!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF1B365D),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SomarSans',
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: BigButton(
                      text: "تابع",
                      buttonType: ButtonType.secondary,
                      onPressed: () {
                        context.pushReplacementNamed(
                          AppRoutes.chapters.name,
                          pathParameters: {
                            'unitId': unitId.toString(),
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: BigButton(
                      text: "مشاركة",
                      buttonType: ButtonType.primary,
                      onPressed: () {
                        StreakShareUtils.shareStreak(context, streak);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumericDayItem(int dayNumber, bool isCompleted) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$dayNumber",
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF00C4F6) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF00C4F6).withValues(alpha: isCompleted ? 1 : 0.3),
                width: 2,
              ),
            ),
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18.sp,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
