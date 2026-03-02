import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double? fontSize;
  final bool showText;
  
  const AppLogo({
    super.key,
    this.fontSize,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showText) return const SizedBox.shrink();
    
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Tay',
            style: TextStyle(
              fontSize: fontSize ?? 32.sp,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).brightness == Brightness.light 
                  ? AppColors.textBlack 
                  : Colors.white,
              fontFamily: 'SomarSans',
              letterSpacing: -1,
            ),
          ),
          TextSpan(
            text: 'ssir',
            style: TextStyle(
              fontSize: fontSize ?? 32.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryColor,
              fontFamily: 'SomarSans',
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}
