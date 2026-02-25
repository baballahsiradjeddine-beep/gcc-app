import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:tayssir/resources/resources.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreakShareUtils {
  static Future<void> shareStreak(
      BuildContext context, StreakModel streak) async {
    // Initialize date formatting for Arabic to avoid LocaleDataException
    await initializeDateFormatting('ar');
    
    final screenshotController = ScreenshotController();

    // Show a small loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('جاري تجهيز الصورة للمشاركة...'),
          duration: Duration(milliseconds: 700)),
    );

    try {
      final imageBytes = await screenshotController.captureFromWidget(
        _buildShareDesign(streak),
        delay: const Duration(milliseconds: 300), // More delay for assets
        pixelRatio: 3.0,
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
        width: 360,
        height: 720, // Increased height to prevent overflow
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/streak_share_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Safe overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
              child: Column(
                children: [
                  // App Branding
                  const Text(
                    'Bayan',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'SomarSans',
                      letterSpacing: 1.5,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 12)],
                    ),
                  ),
                  
                  const Spacer(flex: 1),

                  // Achievement Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.98),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("🔥", style: TextStyle(fontSize: 50)),
                        const SizedBox(height: 8),
                        Text(
                          "${streak.currentStreak}",
                          style: const TextStyle(
                            fontSize: 75,
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
                        const SizedBox(height: 12),
                        Container(height: 1, width: 80, color: const Color(0xFFEEEEEE)),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('dd MMMM yyyy', 'ar').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B365D).withValues(alpha: 0.5),
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Mascot
                  SizedBox(
                    height: 120,
                    child: SvgPicture.asset(
                      SVGs.titoGood,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Motivational Footer
                  const Text(
                    'الباكالوريا في الجيب مع بيان! 🚀',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'SomarSans',
                      shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                    ),
                  ),
                  
                  const SizedBox(height: 15),

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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
