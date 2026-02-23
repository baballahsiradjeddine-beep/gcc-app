import 'package:flutter/material.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/features/streaks/utils/streak_share_utils.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class StreakDialogContent extends StatelessWidget {
  final StreakModel streak;

  const StreakDialogContent({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "مبارك لك 🎉",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFFF28F3B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${streak.currentStreak} أيام متواصلة",
              style: const TextStyle(
                fontSize: 26,
                color: Color(0xFFF28F3B),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),

            // The Fire Emoji
            const Text(
              "🔥",
              style: TextStyle(fontSize: 120),
            ),

            const SizedBox(height: 30),

            // The 7 days widget Container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: streak.history
                        .map((day) => _buildDayItem(day))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "سلسلتك تكبر مع كل يوم دراسي، لكن إذا توقفت ليوم واحد فقط، تبدأ من الصفر!\nحافظ على استمراريتك وحقق التقدم!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textBlack.withOpacity(0.8),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "لا تتوقف... كل يوم يصنع فارقاً!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkColor,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 35),

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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "مشاركة",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
            fontSize: 9, // Small text for days
            color: day.isToday ? AppColors.darkColor : AppColors.textBlack,
            fontWeight: day.isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: day.studied ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
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
                  size: 20,
                )
              : null,
        ),
      ],
    );
  }
}

void showStreakDialog(BuildContext context, StreakModel streak) {
  showDialog(
    context: context,
    builder: (context) => StreakDialogContent(streak: streak),
  );
}
