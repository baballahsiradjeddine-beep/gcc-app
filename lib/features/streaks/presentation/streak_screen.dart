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
    return AppScaffold(
      onPopScope: () {},
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              // Header Section
              SizedBox(height: 10.h),
              Text(
                "مبارك لك 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "${streak.currentStreak} أيام متواصلة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              
              const Spacer(flex: 1),

              // Responsive Fire Emoji
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB74D).withValues(alpha: 0.1),
                ),
                child: Text(
                  "🔥",
                  style: TextStyle(fontSize: 80.sp),
                ),
              ),

              const Spacer(flex: 1),

              // Card Section - Optimized for space
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: streak.history
                          .map((day) => _buildDayItem(day))
                          .toList(),
                    ),
                    SizedBox(height: 14.h),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1.2),
                    SizedBox(height: 10.h),
                    Text(
                      "سلسلتك تكبر مع كل يوم دراسي، لكن إذا توقفت ليوم واحد فقط، تبدأ من الصفر!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1B365D),
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

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

              SizedBox(height: 20.h),

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
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayItem(StreakDay day) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.dayName.substring(0, 1), // Only first letter if it overflows
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF4B5563).withValues(alpha: 0.8),
              fontWeight: day.isToday ? FontWeight.bold : FontWeight.w600,
              fontFamily: 'SomarSans',
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: day.studied ? const Color(0xFF00C4F6) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF00C4F6).withValues(alpha: day.studied ? 1 : 0.3),
                width: 2,
              ),
            ),
            child: day.studied
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
