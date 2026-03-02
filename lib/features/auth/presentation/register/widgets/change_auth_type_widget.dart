import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';

class ChangeAuthTypeWidget extends ConsumerWidget {
  const ChangeAuthTypeWidget({
    super.key,
    this.isLogin = false,
  });

  final bool isLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? AppStrings.dontHaveAccount : "هل لديك حساب بالفعل ؟",
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'SomarSans',
          ),
        ),
        TextButton(
          onPressed: () {
            context.goNamed(isLogin ? AppRoutes.register.name : AppRoutes.login.name);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isLogin ? "قم بإنشاء حساب" : AppStrings.login,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
              decoration: TextDecoration.none, // Match the premium look
            ),
          ),
        ),
      ],
    );
  }
}
