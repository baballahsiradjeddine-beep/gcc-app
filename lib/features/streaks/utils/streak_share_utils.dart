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
        width: 1080 /
            3, // Roughly mobile size, rendered at 3.0 pixelRatio -> 1080px
        height: 1920 / 3,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/streak_share_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Safe Area Padding
            Positioned.fill(
              top: 50,
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Alhamdulillah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '🙏 الحمد لله',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // The Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE97A2E)
                          .withValues(alpha: 0.95), // Adjust to match
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          streak.currentStreak.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                  color: Color(0xFFB54C0A),
                                  offset: Offset(4, 4),
                                  blurRadius: 0),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'أيام دراسية دون انقطاع',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 1.5,
                          width: double.infinity,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          DateFormat('dd MMMM yyyy', 'ar').format(DateTime
                              .now()), // Assuming arabic locale or just use simple format
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Text below
                  const Text(
                    'مع منصة Bayan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'الباك في الجيب Sur! 🚀✨',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD65C13), // darker orange
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'بكالوريا 2025',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Logo Placeholder (Text for now or logo if you have an asset!)
                  /*
                  Image.asset(
                    'assets/images/logo.png', // Or bayan logo
                    height: 50,
                  ),
                  */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bayan',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
