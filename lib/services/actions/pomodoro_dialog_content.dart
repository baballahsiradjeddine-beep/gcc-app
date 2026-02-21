import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/constants/strings.dart';

import '../../common/app_buttons/big_button.dart';
import '../../resources/resources.dart';

class PomodoroDialogContent extends StatelessWidget {
  const PomodoroDialogContent({
    super.key,
    required this.onContinue,
  });
  final Function() onContinue;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    SVGs.titoPomodoroDone,
                    height: 200.h,
                  ),
                  10.verticalSpace,
                  BigButton(
                      text: AppStrings.continueText,
                      onPressed: () {
                        onContinue();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
