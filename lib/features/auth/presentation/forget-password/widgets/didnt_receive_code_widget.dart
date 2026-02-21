import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../../../../../common/app_buttons/custom_text_button.dart';

class DidntReceiveCodeWidget extends StatelessWidget {
  const DidntReceiveCodeWidget(
      {super.key, required this.onPressed, required this.canResend});
  final VoidCallback onPressed;
  final bool canResend;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.didntReceiveCode,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
        4.horizontalSpace,
        CustomTextButton(
          text: AppStrings.resendCode,
          onPressed: canResend ? onPressed : null,
          customColor: AppColors.darkBlue,
        ),
      ],
    );
  }
}
