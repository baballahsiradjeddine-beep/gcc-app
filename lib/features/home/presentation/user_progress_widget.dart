import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/home/presentation/home_screen.dart';
import 'package:tayssir/features/units/widgets/unit_circle_progress_widget.dart';
import 'package:tayssir/features/units/widgets/unit_progress_widget.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
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
            ref.watch(userNotifierProvider).requireValue?.points ?? 0;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: const [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.05),
              //   blurRadius: 10,
              //   offset: const Offset(0, 4),
              // ),
              // BoxShadow(
              //   color: AppColors.primaryColor.withOpacity(0.1),
              //   blurRadius: 6,
              //   offset: const Offset(0, 2),
              // ),
            ],
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular progress indicator

              // Chapter completion info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(0.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [
                        // BoxShadow(
                        //   color: Colors.black.withOpacity(0.05),
                        //   blurRadius: 10,
                        //   offset: const Offset(0, 4),
                        // ),
                        // BoxShadow(
                        //   color: AppColors.primaryColor.withOpacity(0.1),
                        //   blurRadius: 6,
                        //   offset: const Offset(0, 2),
                        // ),
                      ],
                      // border: Border.all(
                      // color: AppColors.primaryColor.withOpacity(0.2),
                      // width: 1.5,
                      // ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الفصول المكتملة',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Text(
                              '$completedChapters / $totalChapters',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                            8.horizontalSpace,
                            Icon(
                              Icons.book_rounded,
                              color: AppColors.primaryColor,
                              size: 24.w,
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Text(
                          'واصل رحلة التعلم! 🚀',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: UnitCircleProgressWidget(
                  progress: progress * 100,
                  size: 80.w,
                  borderWidth: 10.w,
                  padding: 0,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
