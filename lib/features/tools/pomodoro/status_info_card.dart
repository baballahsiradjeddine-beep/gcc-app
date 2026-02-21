import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class StatusInfoCard extends StatelessWidget {
  final String title;
  final String? value;
  final Color color;
  final double titleFontSize;
  final double valueFontSize;
  final bool shouldExpand;

  const StatusInfoCard({
    super.key,
    required this.title,
    this.value,
    required this.color,
    this.titleFontSize = 13,
    this.valueFontSize = 13,
    this.shouldExpand = true,
  });

  @override
  Widget build(BuildContext context) {
    if (shouldExpand) {
      return Expanded(
        child: Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              5.verticalSpace,
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(
                    fontSize: valueFontSize.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 20.w,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          5.verticalSpace,
          if (value != null)
            Text(
              value!,
              style: TextStyle(
                fontSize: valueFontSize.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
