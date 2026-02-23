// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/tools/card_swipper/models/card_model.dart';
import 'package:tayssir/features/tools/card_swipper/card_pattern_painter.dart';
import 'package:tayssir/features/tools/card_swipper/state/card_swipper_controller.dart';

class TopicCard extends ConsumerWidget {
  final CardModel item;
  final int index;

  const TopicCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get different gradient colors based on category
    List<Color> cardColors = ref
        .watch(cardSwipperControllerProvider)
        .getCardColorsPerCat(item.categoryId);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardColors,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColors[0].withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern (subtle)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CustomPaint(
                painter:
                    CardPatternPainter(color: Colors.white.withOpacity(0.2)),
              ),
            ),
          ),

          // Card number indicator
          Positioned(
            top: 15.h,
            left: 15.w,
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${item.id}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(24.0.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category label
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    ref
                        .watch(cardSwipperControllerProvider)
                        .allCategories
                        .where(
                          (element) => element.id == item.categoryId,
                        )
                        .first
                        .name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                20.verticalSpace,

                // Main topic content
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Description
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20.h),

                // Swipe indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe,
                      color: Colors.white.withOpacity(0.7),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'اسحب للمتابعة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get different color schemes based on category
  // List<Color> _getCardColors(int categoryId) {
  //   // switch (category) {
  //   //   case 'الفيزياء':
  //   //     return [Colors.blue.shade500, Colors.indigo.shade700];
  //   //   case 'الرياضيات':
  //   //     return [Colors.purple.shade400, Colors.deepPurple.shade700];
  //   //   case 'الكيمياء':
  //   //     return [Colors.teal.shade400, Colors.green.shade700];
  //   //   case 'الأدب العربي':
  //   //     return [Colors.orange.shade400, Colors.deepOrange.shade700];
  //   //   case 'التاريخ والجغرافيا':
  //   //     return [Colors.pink.shade400, Colors.red.shade700];
  //   //   default:
  //   //     return [Colors.orange.shade400, Colors.deepOrange.shade700];
  //   // }

  // }
}
