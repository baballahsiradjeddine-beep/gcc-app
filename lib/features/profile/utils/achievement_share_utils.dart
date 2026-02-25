import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AchievementShareUtils {
  static Future<void> shareAchievementLog(
    BuildContext context, {
    required dynamic user,
    required StreakModel? streak,
    int? completedLessons,
    int? perfectResults,
  }) async {
    // This could involve generating a screenshot or sharing textual data
  }

  final ScreenshotController screenshotController = ScreenshotController();

  Future<String?> captureAchievementImage(dynamic user) async {
    final image = await screenshotController.captureFromWidget(
      Material(
        child: _AchievementShareDesign(user: user),
      ),
      delay: const Duration(milliseconds: 100),
    );

    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/achievement_${DateTime.now().millisecondsSinceEpoch}.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);
    return imagePath;
  }
}

class _AchievementShareDesign extends StatelessWidget {
  final dynamic user;

  const _AchievementShareDesign({required this.user});

  @override
  Widget build(BuildContext context) {
    final badgeColor = user.badge?.color;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF2DD4BF);
    final badgeIconUrl = user.badge?.iconUrl;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor,
            themeColor.withValues(alpha: 0.8),
            themeColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'تيسير - إنجاز جديد! 🏆',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'SomarSans',
            ),
          ),
          const SizedBox(height: 20),
          _ShieldWidget(
            user: user,
            badgeIconUrl: badgeIconUrl,
            themeColor: themeColor,
          ),
          const SizedBox(height: 20),
          _buildAchievementRow(
            icon: SVGs.icPoints,
            title: 'النقاط',
            value: '${user.points}',
            themeColor: themeColor,
          ),
          _buildAchievementRow(
            icon: SVGs.icRank,
            title: 'الرتبة',
            value: user.rank,
            themeColor: themeColor,
          ),
          _buildAchievementRow(
            icon: SVGs.icLevel,
            title: 'المستوى',
            value: '${user.level}',
            themeColor: themeColor,
          ),
          const SizedBox(height: 15),
          const Text(
            'تعلم بذكاء مع تيسير',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'SomarSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _ShieldWidget({
    required dynamic user,
    required String? badgeIconUrl,
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
            avatarSize: 100,
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
            bottom: 22,
            child: Builder(
              builder: (context) {
                final shadowColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.25), themeColor);
                final textStyle = GoogleFonts.balooDa2(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                );
                final points = user.points.toString();

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Bottom Shadow Layer (3D effect)
                    Text(
                      points,
                      style: textStyle.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 8
                          ..color = shadowColor,
                      ),
                    ),
                    // Offset Shadow
                    Transform.translate(
                      offset: const Offset(0, 2),
                      child: Text(
                        points,
                        style: textStyle.copyWith(
                          color: shadowColor,
                        ),
                      ),
                    ),
                    // Stroke Layer
                    Text(
                      points,
                      style: textStyle.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = themeColor,
                      ),
                    ),
                    // Fill Layer (Top)
                    Text(
                      points,
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
