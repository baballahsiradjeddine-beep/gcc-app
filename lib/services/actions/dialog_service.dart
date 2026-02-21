import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/dialog_content.dart';
import 'package:tayssir/services/actions/pomodoro_dialog_content.dart';
import 'package:tayssir/services/actions/sub_done_dialog_content.dart';

enum SubscrptionStatus { pending, success, failure }

class DialogService {
  static void showHintDialog(
      BuildContext context, List<LatexField<String>> hints, String? hintImage) {
    AppLogger.logInfo('hintImage: $hintImage');
    AppLogger.logInfo('hints: $hints');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ExerciceDialogContent(
            items: hints, title: AppStrings.hint, hintImage: hintImage);
      },
    );
  }

  // show remark dialog
  static void showRemarkDialog(BuildContext context,
      List<LatexField<String>> remarks, String? hintImage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ExerciceDialogContent(
          items: remarks,
          title: AppStrings.remark,
          hintImage: hintImage,
        );
      },
    );
  }

  static void showPomodoroDoneDialog(
      BuildContext context, Function() onContinue) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PomodoroDialogContent(
          onContinue: onContinue,
        );
      },
    );
  }

  static void showSubscriptionDoneDialog(
      BuildContext context, Function() onContinue) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SubDoneDialogContent(
          onContinue: onContinue,
          status: SubscrptionStatus.success,
        );
      },
    );
  }

  static void showSubscriptionDialog(
      BuildContext context, Function() onContinue, SubscrptionStatus status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SubDoneDialogContent(
          onContinue: onContinue,
          status: status,
        );
      },
    );
  }

  static void showChapterLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const DialogContent(
          title: 'الدرس مقفل',
          subTitle:
              'يجب أن تحصل على الأقل 50% في التمرين الأخير لفتح هذا الدرس',
        );
      },
    );
  }

  // show need subscription dialog
  static void showNeedSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogContent(
          title: 'ميزة مدفوعة',
          subTitle:
              'هذه الميزة خاصة بالنسخة المدفوعة. للاستفادة من جميع المزايا والمحتوى الحصري، يرجى الاشتراك في الخدمة المدفوعة.',
          buttonText: 'اشترك الآن',
          onPressed: () {
            context.pushNamed(AppRoutes.subscriptionOptions.name);
          },
        );
      },
    );
  }
}

class DialogContent extends HookWidget {
  const DialogContent(
      {super.key,
      required this.title,
      this.subTitle,
      this.onPressed,
      this.onCancel,
      this.buttonText})
      : assert((onPressed == null && buttonText == null) ||
            (onPressed != null && buttonText != null));

  final String? subTitle;
  final String title;
  final String? buttonText;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0.8.sw,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(
                    color: AppColors.greyColor,
                  ),
                  // add subtitle here and make it good and beutiful
                  if (subTitle != null)
                    Text(
                      subTitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.darkColor,
                      ),
                    ),
                  10.verticalSpace,
                  const Divider(
                    color: AppColors.greyColor,
                  ),
                  10.verticalSpace,
                  if (onPressed != null) ...[
                    BigButton(
                        text: buttonText!,
                        buttonType: ButtonType.primary,
                        onPressed: () {
                          context.pop();
                          if (onPressed != null) {
                            onPressed!();
                          }
                        }),
                    10.verticalSpace,
                  ],
                  BigButton(
                      text: 'رجوع',
                      buttonType: onPressed != null
                          ? ButtonType.secondary
                          : ButtonType.primary,
                      onPressed: () {
                        context.pop();
                        if (onCancel != null) {
                          onCancel!();
                        }
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
