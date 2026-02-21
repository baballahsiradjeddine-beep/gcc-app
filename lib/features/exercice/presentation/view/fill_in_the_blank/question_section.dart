import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class QuestionSection extends StatelessWidget {
  const QuestionSection({super.key, required this.question});

  final Widget question;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.greyColor,
        ),
        15.verticalSpace,
        question,
        15.verticalSpace,
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.greyColor,
        ),
      ],
    );
  }
}
