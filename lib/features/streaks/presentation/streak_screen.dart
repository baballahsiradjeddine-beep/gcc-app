import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Text(
                "مبارك لك 🎉",
                style: TextStyle(
                  fontSize: 28.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "${streak.currentStreak} أيام متواصلة",
                style: TextStyle(
                  fontSize: 34.sp,
                  color: const Color(0xFFF28F3B),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              const Spacer(flex: 1),

              // The Fire Emoji / Image
              Text(
                "🔥",
                style: TextStyle(fontSize: 150.sp),
              ),

              const Spacer(flex: 1),

              // The 7 days widget Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: streak.history
                          .map((day) => _buildDayItem(day))
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1.5),
                    SizedBox(height: 15.h),
                    Text(
                      "سلسلتك تكبر مع كل يوم دراسي، لكن إذا توقفت ليوم واحد فقط، تبدأ من الصفر!\nحافظ على استمراريتك وحقق التقدم!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1B365D),
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              Text(
                "لا تتوقف... كل يوم يصنع فارقاً!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF1B365D),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'SomarSans',
                ),
              ),

              SizedBox(height: 40.h),

              // Actions
              Row(
                children: [
                  // Continue Button (Light Blue)
                  Expanded(
                    child: _buildCustomButton(
                      text: "تابع",
                      backgroundColor: const Color(0xFFECF6FF),
                      textColor: const Color(0xFF00C4F6),
                      onPressed: () {
                        context.pushReplacementNamed(
                          AppRoutes.chapters.name,
                          pathParameters: {
                            'unitId': unitId.toString(),
                          },
                        );
                      },
                      hasShadow: true,
                      shadowColor: const Color(0x99C4F6F6),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // Share Button (Filled Cyan)
                  Expanded(
                    child: _buildCustomButton(
                      text: "مشاركة",
                      backgroundColor: const Color(0xFF00C4F6),
                      textColor: Colors.white,
                      onPressed: () {
                        StreakShareUtils.shareStreak(context, streak);
                      },
                      hasShadow: true,
                      shadowColor: const Color(0x9900C4F6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    bool hasShadow = false,
    Color? shadowColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: shadowColor ?? textColor.withValues(alpha: 0.3),
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayItem(StreakDay day) {
    return Column(
      children: [
        Text(
          day.dayName,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF1B365D),
            fontWeight: day.isToday ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'SomarSans',
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: day.studied ? const Color(0xFF00C4F6) : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color(0xFF00C4F6),
              width: 2,
            ),
          ),
          child: day.studied
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24.sp,
                )
              : null,
        ),
      ],
    );
  }
}
