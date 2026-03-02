import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/units/widgets/unit_circle_progress_widget.dart';

class TayssirProgressWidget extends StatelessWidget {
  const TayssirProgressWidget({
    super.key,
    this.name,
    required this.upperText,
    required this.progress,
    this.direction = TextDirection.rtl,
    this.startColor = const Color(0xffF037A5),
    this.endColor = const Color(0xffF037A5),
    this.imageUrl = '',
  });

  final String? name;
  final String upperText;
  final double progress;
  final TextDirection direction;
  final Color startColor;
  final Color endColor;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h), // Reduced vertical padding to prevent making it too tall
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffEC4899), Color(0xffBE185D)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(32.r), // Standardized border radius matched exactly to SubscribeButton
        boxShadow: [
          BoxShadow(
            color: const Color(0xffEC4899).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Progress on the RIGHT (Start of RTL Row)
            UnitCircleProgressWidget(
              progress: progress,
              size: 75, // Increased size to feel proportional to the ad banners
              borderWidth: 5,
              padding: 0,
              color: const Color(0xff00B4D8), // Set filled progress color to blue
            ),

            20.horizontalSpace, // Increased gap

            // 2. Text on the LEFT (End of RTL Row)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Start is Right in RTL
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    upperText,
                    textAlign: TextAlign.start,
                    maxLines: 2, // Allow wrapping if needed
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp, // Slightly reduced to fit multi-line titles
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                      height: 1.1,
                    ),
                  ),
                  if (name != null && name!.isNotEmpty) ...[
                    4.verticalSpace,
                    Text(
                      name!.replaceAll('<br>', ' ').replaceAll('<br class="br-hide">', ' '),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmojiForSubject(String title) {
    if (title.contains('رياضيات')) return '👩‍🎤';
    if (title.contains('اجتماعيات')) return '🧑‍🏫';
    if (title.contains('إنجليزية')) return '🧕';
    if (title.contains('عربية')) return '🕌';
    if (title.contains('فرنسية')) return '🇫🇷';
    if (title.contains('علوم')) return '🔬';
    if (title.contains('فيزياء')) return '🧪';
    if (title.contains('فلسفة')) return '🤔';
    if (title.contains('إسلامية')) return '🌙';
    return '🤖';
  }
}
