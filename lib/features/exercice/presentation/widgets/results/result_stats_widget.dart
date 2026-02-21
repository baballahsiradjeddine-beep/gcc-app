import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ResultStatsWidget extends StatelessWidget {
  const ResultStatsWidget({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    this.startColor = AppColors.primaryColor,
    this.endColor = const Color(0xff0080FF),
  });

  final String value;
  final String title;
  final String icon;
  final Color startColor;
  final Color endColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: startColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  startColor,
                  endColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.horizontalSpace,
                SvgPicture.asset(
                  icon,
                  height: 20.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
