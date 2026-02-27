import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';

class AchievementShareUtils {
  static Future<void> shareAchievementLog(
    BuildContext context, {
    required dynamic user,
    required StreakModel? streak,
    int? completedLessons,
    int? perfectResults,
  }) async {
    final screenshotController = ScreenshotController();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري تجهيز صورة الإنجازات...'),
          duration: Duration(milliseconds: 800),
        ),
      );
    }

    try {
      final imageBytes = await screenshotController.captureFromWidget(
        _AchievementShareDesign(
          user: user,
          streak: streak,
          completedLessons: completedLessons ?? 0,
          perfectResults: perfectResults ?? 0,
        ),
        delay: const Duration(milliseconds: 600),
        pixelRatio: 3.0,
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/achievement_log_share.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(imagePath)]);
    } catch (e) {
      debugPrint('Error generating achievement share: $e');
    }
  }
}

class _AchievementShareDesign extends StatelessWidget {
  final dynamic user;
  final StreakModel? streak;
  final int completedLessons;
  final int perfectResults;

  const _AchievementShareDesign({
    required this.user,
    required this.streak,
    required this.completedLessons,
    required this.perfectResults,
  });

  @override
  Widget build(BuildContext context) {
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

    final badgeColor = user.badge?.color;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 360,
          height: 640,
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/achievement_share_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Main Content
              Column(
                children: [
                  const SizedBox(height: 100),

                  // Shield
                  _buildShield(
                    context,
                    user.points,
                    rank,
                    badgeIconUrl: user.badge?.completeIconUrl,
                    themeColor: themeColor,
                  ),

                  const SizedBox(height: 15),

                  // Achievement Rows
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _buildAchievementRow(
                          icon: SVGs.icStreakAchievement,
                          title: "عدد أيام الدراسة :",
                          value: "${streak?.currentStreak ?? 0} أيام متواصلة",
                          themeColor: const Color(0xFFF97316),
                        ),
                        _buildAchievementRow(
                          icon: SVGs.icPointsAchievement,
                          title: "إجمالي النقاط :",
                          value: "${user.points} نقطة",
                          themeColor: const Color(0xFF00C4F6),
                        ),
                        _buildAchievementRow(
                          icon: SVGs.icLessonsAchievement,
                          title: "الدروس المكتملة :",
                          value: "$completedLessons درس",
                          themeColor: const Color(0xFF22C55E),
                        ),
                        _buildAchievementRow(
                          icon: SVGs.icPerfectAchievement,
                          title: "النتائج المثالية :",
                          value: "$perfectResults درس",
                          themeColor: const Color(0xFFD946EF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShield(
    BuildContext context,
    int points,
    String rank, {
    String? badgeIconUrl,
    required Color themeColor,
  }) {
    return SizedBox(
      height: 150,
      width: 140,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ShieldBadge(
            userAvatarUrl: user.completeProfilePic,
            badgeIconUrl: badgeIconUrl,
            themeColor: themeColor,
            width: 110,
            height: 130,
            avatarPaddingTop: 28,
            avatarSize: 98,
          ),

          // Stars (Fallback Only)
          if (badgeIconUrl == null) ...[
            const Positioned(
              top: 35,
              left: 42,
              child: Icon(Icons.star, color: Colors.white70, size: 12),
            ),
            const Positioned(
              top: 35,
              right: 42,
              child: Icon(Icons.star, color: Colors.white70, size: 12),
            ),
          ],

          // Rank Label (Badge in Top)
          // Level Number (Custom Styled Dynamic Number)
          Positioned(
            bottom: 18,
            child: Builder(
              builder: (context) {
                final shadowColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.25), themeColor);
                final textStyle = GoogleFonts.balooDa2(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                );
                final pointsStr = points.toString();

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Bottom Shadow Layer (3D effect)
                    Text(
                      pointsStr,
                      style: textStyle.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6,
                          color: shadowColor,
                      ),
                    ),
                    // Offset Shadow
                    Transform.translate(
                      offset: const Offset(0, 2),
                      child: Text(
                        pointsStr,
                        style: textStyle.copyWith(
                          color: shadowColor,
                        ),
                      ),
                    ),
                    // Stroke Layer
                    Text(
                      pointsStr,
                      style: textStyle.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = themeColor,
                      ),
                    ),
                    // Fill Layer (Top)
                    Text(
                      pointsStr,
                      style: textStyle.copyWith(
                        color: const Color(0xFFFBF0FC),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow({
    required String icon,
    required String title,
    required String value,
    required Color themeColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withValues(alpha: 0.5), width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'SomarSans',
                  ),
                ),
                const SizedBox(height: 1),
                _StrokeText(
                  text: value,
                  fontSize: 17,
                  strokeColor: themeColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(icon, width: 26, height: 30),
        ],
      ),
    );
  }
}

class _StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color strokeColor;
  final Color textColor;

  const _StrokeText({
    required this.text,
    required this.fontSize,
    required this.strokeColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = strokeColor,
          ),
        ),
        // Fill
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
            color: textColor,
          ),
        ),
      ],
    );
  }
}
