import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/streaks/presentation/streak_notifier.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/features/profile/utils/achievement_share_utils.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/resources.dart';

class AchievementLogScreen extends ConsumerStatefulWidget {
  const AchievementLogScreen({super.key});

  @override
  ConsumerState<AchievementLogScreen> createState() => _AchievementLogScreenState();
}

class _AchievementLogScreenState extends ConsumerState<AchievementLogScreen> {
  final screenshotController = ScreenshotController();

  Future<void> _shareScreen() async {
    final user = ref.read(userNotifierProvider).requireValue!;
    final streak = ref.read(streakNotifierProvider).asData?.value;
    final dataState = ref.read(dataProvider);

    final completedLessons = dataState.contentData.chapters
        .where((e) => e.progress >= 50)
        .length;
    final perfectResults = dataState.contentData.chapters
        .where((e) => e.progress == 100)
        .length;

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
    final user = ref.watch(userNotifierProvider).requireValue!;
    final streak = ref.watch(streakNotifierProvider).asData?.value;
    final dataState = ref.watch(dataProvider);

    final completedLessons = dataState.contentData.chapters
        .where((e) => e.progress >= 50)
        .length;
    final perfectResults = dataState.contentData.chapters
        .where((e) => e.progress == 100)
        .length;

    final level = (user.points / 100).floor();
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

    return AppScaffold(
      topSafeArea: true,
      paddingX: 0,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    "سجل الإنجازات",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
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
                      badgeIconUrl: user.badge?.iconUrl,
                      badgeColor: user.badge?.color,
                    ),

                    15.verticalSpace,

                    // Achievement Cards
                    _AchievementCard(
                      icon: SVGs.icStreakAchievement,
                      title: "عدد أيام الدراسة دون انقطاع :",
                      value: "${streak?.currentStreak ?? 0} أيام متواصلة",
                      valueColor: const Color(0xFFF97316),
                    ),
                    12.verticalSpace,
                    _AchievementCard(
                      icon: SVGs.icPointsAchievement,
                      title: "إجمالي النقاط :",
                      value: "${user.points} نقطة",
                      valueColor: const Color(0xFF00C4F6),
                    ),
                    12.verticalSpace,
                    _AchievementCard(
                      icon: SVGs.icLessonsAchievement,
                      title: "إجمالي الدروس المكتملة :",
                      value: "$completedLessons درس",
                      valueColor: const Color(0xFF22C55E),
                    ),
                    12.verticalSpace,
                    _AchievementCard(
                      icon: SVGs.icPerfectAchievement,
                      title: "إجمالي النتائج المثالية :",
                      value: "$perfectResults درس",
                      valueColor: const Color(0xFFD946EF),
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
      height: 195.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Shield Base (Fallback if no badge icon)
          if (badgeIconUrl == null)
            Center(
              child: CustomPaint(
                size: Size(130.w, 150.h),
                painter: _ShieldPainter(color: themeColor),
              ),
            ),

          // User Avatar (Bottom Layer)
          // Clipped to the exact shield shape to prevent bleed
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: _ShieldClipper(),
              child: Container(
                width: 140.w,
                height: 165.h,
                color: Colors.white,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 40.h),
                child: Container(
                  width: 125.w,
                  height: 125.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userAvatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Badge Design (Top Layer - Overlap)
          if (badgeIconUrl != null)
            Positioned(
              top: 0,
              child: CachedNetworkImage(
                imageUrl: badgeIconUrl!,
                width: 140.w,
                height: 165.h,
                fit: BoxFit.contain,
              ),
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
            bottom: 28.h,
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
    final shadowColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.25), themeColor);
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
              ..strokeWidth = 10
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
              ..strokeWidth = 6
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

class _ShieldPainter extends CustomPainter {
  final Color color;
  _ShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.8), color],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.9, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.1);
    path.close();

    canvas.drawPath(path, paint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _AchievementCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color valueColor;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
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

class _ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Even tighter curved shield path to definitively hide circle edges
    path.moveTo(size.width * 0.15, size.height * 0.08); 
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.85, size.height * 0.08);
    path.lineTo(size.width * 0.92, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.98, size.width * 0.08, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
