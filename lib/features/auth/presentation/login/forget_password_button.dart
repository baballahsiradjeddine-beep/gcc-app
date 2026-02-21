import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../../../../router/app_router.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.pushNamed(AppRoutes.forgetPassword.name);
        },
        child: Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: AppColors.darkColor,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
