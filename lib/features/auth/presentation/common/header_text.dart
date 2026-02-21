import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.darkColor,
          fontSize: 26.sp,
          fontWeight: FontWeight.bold),
    );
  }
}
