import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:intl/intl.dart' hide TextDirection;

class StreakShareUtils {
  static Future<void> shareStreak(
      BuildContext context, StreakModel streak) async {
    // Initialize date formatting for Arabic to avoid LocaleDataException
    await initializeDateFormatting('ar');
    
    final screenshotController = ScreenshotController();

    // Show a small loading indicator or snackbar if rendering takes a second
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('جاري تجهيز الصورة للمشاركة...'),
          duration: Duration(milliseconds: 500)),
    );

    try {
      final imageBytes = await screenshotController.captureFromWidget(
        _buildShareDesign(streak),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0, // High quality
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/streak_share.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(imagePath)],
        text:
            'أنا في حماس دراسي متواصل لمدة ${streak.currentStreak} أيام على منصة Bayan! 🔥🚀 شاركني التحدي!',
      );
    } catch (e) {
      debugPrint('Error generating share image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء إنشاء الصورة: $e')),
        );
      }
    }
  }

  static Widget _buildShareDesign(StreakModel streak) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 360, // Standard mobile width
        height: 640, // Standard mobile height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1B365D), // Deep Bayan Blue
              const Color(0xFF2E5A9E), // Lighter Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Abstract Background Patterns (Circles)
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  // App Branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bayan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'SomarSans',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(flex: 1),

                  // The Achievement Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "🔥",
                          style: TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${streak.currentStreak}",
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFF28F3B),
                            height: 1.0,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        const Text(
                          'أيام دراسية متواصلة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B365D),
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 1,
                          width: 100,
                          color: const Color(0xFFEEEEEE),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd MMMM yyyy', 'ar').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B365D).withValues(alpha: 0.6),
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Tito Mascot Cheering
                  SizedBox(
                    height: 120,
                    child: SvgPicture.asset(
                      SVGs.titoPerfect, // Best Tito for achievements
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Motivational Text
                  const Text(
                    'الباكالوريا في الجيب مع بيان! 🚀',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  
                  const SizedBox(height: 15),

                  // Bottom Badge
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28F3B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'بكالوريا 2025',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
