import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/features/streaks/utils/streak_share_utils.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              SizedBox(height: 10.h),
              Text(
                "مبارك لك 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
              Text(
                "$currentStreak أيام متواصلة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              
              const Spacer(flex: 1),

              // Glowing Fire Section - Adds visual depth
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFB74D).withValues(alpha: 0.25),
                          const Color(0xFFFFB74D).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.1),
                    ),
                    child: Text(
                      "🔥",
                      style: TextStyle(fontSize: 70.sp),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

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
                      "استمر في العطاء، فكل خطوة صغيرة تقربك من القمة! 🚀",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1B365D),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // The Mascot (Tito) Cheering - Fills the gap beautifully
              SizedBox(
                height: 110.h,
                child: SvgPicture.asset(
                  SVGs.titoGood,
                  fit: BoxFit.contain,
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

              SizedBox(height: 15.h),

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
