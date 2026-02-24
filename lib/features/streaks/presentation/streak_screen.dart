import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/features/streaks/utils/streak_share_utils.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              const Text(
                "مبارك لك 🎉",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFFF28F3B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${streak.currentStreak} أيام متواصلة",
                style: const TextStyle(
                  fontSize: 32,
                  color: Color(0xFFF28F3B),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 30),

              // The Fire Emoji
              const Text(
                "🔥",
                style: TextStyle(fontSize: 140),
              ),

              const SizedBox(height: 40),

              // The 7 days widget Container
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: streak.history
                          .map((day) => _buildDayItem(day))
                          .toList(),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "سلسلتك تكبر مع كل يوم دراسي، لكن إذا توقفت ليوم واحد فقط، تبدأ من الصفر!\nحافظ على استمراريتك وحقق التقدم!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlack.withOpacity(0.8),
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              const Text(
                "لا تتوقف... كل يوم يصنع فارقاً!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 30),

              // Actions - Fixed for RTL
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        StreakShareUtils.shareStreak(context, streak);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "مشاركة",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.pushReplacementNamed(
                          AppRoutes.chapters.name,
                          pathParameters: {
                            'unitId': unitId.toString(),
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                            color: AppColors.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "تابع",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
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
            fontSize: 11, // Small text for days
            color: day.isToday ? AppColors.darkColor : AppColors.textBlack,
            fontWeight: day.isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: day.studied ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: day.studied
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: day.studied
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                )
              : null,
        ),
      ],
    );
  }
}
