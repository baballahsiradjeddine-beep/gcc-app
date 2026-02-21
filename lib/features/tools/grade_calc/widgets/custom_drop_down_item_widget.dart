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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20.w,
        ),
        Text(itemName,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
