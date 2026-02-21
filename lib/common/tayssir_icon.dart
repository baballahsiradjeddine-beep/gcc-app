import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class TayssirIcon extends StatelessWidget {
  const TayssirIcon({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      colorFilter:
          const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
      height: 20.h,
    );
  }
}
