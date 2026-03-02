import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/features/streaks/presentation/streak_notifier.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/features/profile/utils/achievement_share_utils.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/resources.dart';

class AchievementLogScreen extends ConsumerStatefulWidget {
  const AchievementLogScreen({super.key});

  @override
  ConsumerState<AchievementLogScreen> createState() =>
      _AchievementLogScreenState();
}

class _AchievementLogScreenState extends ConsumerState<AchievementLogScreen> {
  final screenshotController = ScreenshotController();

  Future<void> _shareScreen() async {
    final user = ref.read(userNotifierProvider).valueOrNull;
    if (user == null) return;
    
    final streak = ref.read(streakNotifierProvider).asData?.value;
    final dataState = ref.read(dataProvider);

    final completedLessons =
        dataState.contentData.chapters.where((e) => e.progress >= 50).length;
    final perfectResults =
        dataState.contentData.chapters.where((e) => e.progress == 100).length;

    await AchievementShareUtils.shareAchievementLog(
      context,
      user: user,
      streak: streak,
      completedLessons: completedLessons,
      perfectResults: perfectResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider).valueOrNull;
    if (user == null) {
      return const AppScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final streak = ref.watch(streakNotifierProvider).asData?.value;
    final dataState = ref.watch(dataProvider);

    final completedLessons =
        dataState.contentData.chapters.where((e) => e.progress >= 50).length;
    final perfectResults =
        dataState.contentData.chapters.where((e) => e.progress == 100).length;

    String rank = "مبتدئ";
    if (user.points >= 10000) {
      rank = "أسطورة";
    } else if (user.points >= 6000) {
      rank = "متميز";
    } else if (user.points >= 3000) {
      rank = "مثابر";
    } else if (user.points >= 1500) {
      rank = "مستكشف";
    } else if (user.points >= 500) {
      rank = "ناشئ";
    }
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      topSafeArea: false,
      paddingX: 0,
      body: Container(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    const SizedBox(width: 48), // Spacer to balance the arrow on the right
                    const Spacer(),
                    Text(
                      "سجل الإنجازات",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(Icons.arrow_forward, size: 28, color: isDark ? Colors.white : const Color(0xFF1F2937)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      10.verticalSpace,
                      // Shield Section
                      _ShieldWidget(
                        userAvatarUrl: user.completeProfilePic,
                        level: user.points,
                        rank: rank,
                        badgeIconUrl: user.badge?.completeIconUrl,
                        badgeColor: user.badge?.color,
                      ),

                      15.verticalSpace,

                      // Achievement Cards
                      _AchievementCard(
                        icon: SVGs.icStreakAchievement,
                        title: "عدد أيام الدراسة دون انقطاع :",
                        value: "${streak?.currentStreak ?? 0} أيام متواصلة",
                        valueColor: const Color(0xFFF97316),
                        isDark: isDark,
                      ),
                      12.verticalSpace,
                      _AchievementCard(
                        icon: SVGs.icPointsAchievement,
                        title: "إجمالي النقاط :",
                        value: "${user.points} نقطة",
                        valueColor: const Color(0xFF00C4F6),
                        isDark: isDark,
                      ),
                      12.verticalSpace,
                      _AchievementCard(
                        icon: SVGs.icLessonsAchievement,
                        title: "إجمالي الدروس المكتملة :",
                        value: "$completedLessons درس",
                        valueColor: const Color(0xFF22C55E),
                        isDark: isDark,
                      ),
                      12.verticalSpace,
                      _AchievementCard(
                        icon: SVGs.icPerfectAchievement,
                        title: "إجمالي النتائج المثالية :",
                        value: "$perfectResults درس",
                        valueColor: const Color(0xFFD946EF),
                        isDark: isDark,
                      ),

                      20.verticalSpace,
                    ],
                  ),
                ),
              ),

              // Share Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                child: BigButton(
                  text: "مشاركة",
                  onPressed: _shareScreen,
                  buttonType: ButtonType.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShieldWidget extends StatelessWidget {
  final String userAvatarUrl;
  final int level;
  final String rank;
  final String? badgeIconUrl;
  final String? badgeColor;

  const _ShieldWidget({
    required this.userAvatarUrl,
    required this.level,
    required this.rank,
    this.badgeIconUrl,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor!.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);

    return SizedBox(
      height: 230.h, // Increased from 195.h
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ShieldBadge(
            userAvatarUrl: userAvatarUrl,
            badgeIconUrl: badgeIconUrl,
            themeColor: themeColor,
            width: 170.w, // Increased from 140.w
            height: 200.h, // Increased from 165.h
            avatarPaddingTop: 46.h, // Adjusted
            avatarSize: 142.w, // Increased
            avatarOffsetX: -3.w,
          ),

          // Stars (Only show if no badge icon or as part of custom design)
          if (badgeIconUrl == null) ...[
            Positioned(
              top: 45.h,
              left: 55.w,
              child: const Icon(Icons.star, color: Colors.white70, size: 14),
            ),
            Positioned(
              top: 45.h,
              right: 55.w,
              child: const Icon(Icons.star, color: Colors.white70, size: 14),
            ),
          ],

          // Level Number (Custom Styled Dynamic Number)
          Positioned(
            bottom: 24.h,
            child: _LevelNumber(
              number: "$level",
              themeColor: themeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelNumber extends StatelessWidget {
  final String number;
  final Color themeColor;

  const _LevelNumber({required this.number, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final shadowColor =
        Color.alphaBlend(Colors.black.withValues(alpha: 0.25), themeColor);
    final textStyle = GoogleFonts.balooDa2(
      fontSize: 32.sp,
      fontWeight: FontWeight.w900,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        // Bottom Shadow Layer (3D effect)
        Text(
          number,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8.sp
              ..color = shadowColor,
          ),
        ),
        // Offset Shadow
        Transform.translate(
          offset: const Offset(0, 3),
          child: Text(
            number,
            style: textStyle.copyWith(
              color: shadowColor,
            ),
          ),
        ),
        // Stroke Layer
        Text(
          number,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4.sp
              ..color = themeColor,
          ),
        ),
        // Fill Layer (Top)
        Text(
          number,
          style: textStyle.copyWith(
            color: const Color(0xFFFBF0FC),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color valueColor;
  final bool isDark;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          SvgPicture.asset(icon, width: 24.w, height: 28.h),
          10.horizontalSpace,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'SomarSans',
                  ),
                ),
                1.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
