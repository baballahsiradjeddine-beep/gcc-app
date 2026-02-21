import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/tayssir_icon.dart';
import 'package:tayssir/features/settings/security/security_screen.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';

class SecurityOptionWidget extends StatelessWidget {
  const SecurityOptionWidget({
    super.key,
    required this.option,
  });

  final TayssirSecurityOption option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //*bad practice
        if (option.changeType == ChangeType.password) {
          context.pushNamed(AppRoutes.resetPassword.name);
          return;
        }
        context.pushNamed(AppRoutes.changeEmail.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyColor,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Text(
              option.title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TayssirIcon(icon: option.iconUrl),
          ],
        ),
      ),
    );
  }
}
