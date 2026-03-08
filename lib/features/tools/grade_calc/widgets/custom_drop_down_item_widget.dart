import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class CustomDropDownItemWidget extends StatelessWidget {
  const CustomDropDownItemWidget({
    super.key,
    required this.itemName,
    required this.iconPath,
  });

  final String itemName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24.w,
          ),
          Text(
            itemName,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textBlack,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
            ),
          ),
        ],
      ),
    );
  }
}
