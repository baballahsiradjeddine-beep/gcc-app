import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/units/widgets/unit_circle_progress_widget.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class UserProgressWidget extends StatelessWidget {
  const UserProgressWidget({
    super.key,
    // required this.courses,
  });

  // final List<MaterialModel> courses;

// // Helper method to create stat items
//   Widget _buildStatItem(
//       {required IconData icon, required String value, required String label}) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: AppColors.primaryColor,
//           size: 22.w,
//         ),
//         6.verticalSpace,
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         4.verticalSpace,
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // final totalCourses = courses.length;
        // final completedCourses =
        // courses.where((course) => course.progress == 100).length;
        // final progress =
        // totalCourses > 0 ? (completedCourses / totalCourses) : 0.0;
        final totalChapters = ref.watch(dataProvider).totalChapters;
        final completedChapters = ref.watch(dataProvider).completedChapters;
        final progress =
            totalChapters > 0 ? (completedChapters / totalChapters) : 0.0;
        final userPoints =
            ref.watch(userNotifierProvider).valueOrNull?.points ?? 0;

        return Container(
          width: double.infinity,
          height: 120.h, // Exact match with SubscribeButton 
          margin: EdgeInsets.symmetric(horizontal: 20.w), // Matched horizontal with ad banners
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF702888), Color(0xFFF037A5)], // Purple to Pink gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r), // Matched EXACTLY with SubscribeButton (blue ad)
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Dot Pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: CustomPaint(
                    painter: DotPatternPainter(),
                  ),
                ),
              ),
              
              // Background Glow
              Positioned(
                top: -50.h,
                right: -50.w,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.white.withOpacity(0.12), Colors.transparent],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h), // Reduced vertical padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Progress Circle (On the LEFT)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: UnitCircleProgressWidget(
                          progress: progress * 100,
                          size: 60.w, // Slightly smaller
                          borderWidth: 5.w,
                          padding: 0,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    16.horizontalSpace,

                    // 2. Chapter completion info (On the RIGHT)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // Align right locally
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الفصول المكتملة',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          4.verticalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.book_rounded,
                                  color: Colors.white,
                                  size: 16.w,
                                ),
                                8.horizontalSpace,
                                Text(
                                  '$completedChapters / $totalChapters',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'SomarSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            'واصل رحلة التعلم 🚀',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 18.0;
    const radius = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
