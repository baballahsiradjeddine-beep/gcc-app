import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/custom_text_button.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? AppStrings.dontHaveAccount : AppStrings.iHaveAccount,
          style: TextStyle(
            color: AppColors.darkColor,
            fontSize: 14.spMin,
          ),
        ),
        5.horizontalSpace,
        CustomTextButton(
          text: isLogin ? AppStrings.register : AppStrings.login,
          onPressed: () {
            context.goNamed(
                isLogin ? AppRoutes.register.name : AppRoutes.login.name);
          },
          customColor: const Color(0xff0088FF),
        ),
      ],
    );
  }
}
