import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/sheets/result_bottom_sheet.dart';

import '../../common/app_buttons/big_button.dart';
import '../../constants/strings.dart';
import '../action_button_sheet.dart';

class BottomSheetService {
  static void showSuccessBottomSheet(
      BuildContext context, bool isCorrect, VoidCallback onNext) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      // barrierColor: Colors.transparent,

      builder: (BuildContext context) {
        return ResultBottomSheet(
          isCorrect: isCorrect,
          onNext: onNext,
        );
      },
    );
  }

  static void showErrorBottomSheet(
      BuildContext context, String message, VoidCallback onNext, bool isLatex) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ResultBottomSheet(
            isCorrect: false,
            onNext: onNext,
            onPopScope: () {},
            message: message,
            isLatex: isLatex,
          );
        });
  }

  static void showLeaveBottomSheet(BuildContext context,
      Function(BuildContext ctx) onLeave, Function(BuildContext ctx) onCancel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ActionButtonSheet(
          title: 'هل أنت متأكد',
          message: AppStrings.leaveMessage,
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: BigButton(
                  text: AppStrings.leaveNow,
                  hasBorder: false,
                  buttonType: ButtonType.secondary,
                  onPressed: () => onLeave(context),
                ),
              ),
              20.horizontalSpace,
              Expanded(
                child: BigButton(
                    text: AppStrings.continueLearning,
                    hasBorder: false,
                    onPressed: () => onCancel(context)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BlurOverlay extends StatelessWidget {
  final Widget child;

  const BlurOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply the blur effect
      child: Container(
        color: Colors.black.withOpacity(0.2), // Add a dim background
        child: child, // Display the actual bottom sheet content
      ),
    );
  }
}
