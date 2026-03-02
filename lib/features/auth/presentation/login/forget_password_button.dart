import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import '../../../../router/app_router.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(AppRoutes.forgetPassword.name);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'هل نسيت كلمة السر ؟',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'SomarSans',
        ),
      ),
    );
  }
}
