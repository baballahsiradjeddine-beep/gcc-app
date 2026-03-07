import 'package:flutter_animate/flutter_animate.dart';
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
import 'package:tayssir/services/actions/badge_celebration_dialog.dart';

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
        return DialogContent(
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

  static void showBadgeCelebrationDialog(
      BuildContext context, String badgeName, String badgeIconUrl, Color badgeColor) {
    showDialog(
      context: context,
      barrierDismissible: true, // Let them dismiss easily
      builder: (context) {
        return BadgeCelebrationDialog(
          badgeName: badgeName,
          badgeIconUrl: badgeIconUrl,
          badgeColor: badgeColor,
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
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Center(
          child: Container(
            width: 0.85.sw,
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF1E293B).withOpacity(0.95) 
                  : AppColors.surfaceWhite.withOpacity(0.95),
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textBlack,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                  
                  if (subTitle != null) ...[
                    16.verticalSpace,
                    Text(
                      subTitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : AppColors.textBody,
                        fontFamily: 'SomarSans',
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                  
                  28.verticalSpace,
                  
                  if (onPressed != null) ...[
                    BigButton(
                        text: buttonText!,
                        buttonType: ButtonType.primary,
                        onPressed: () {
                          context.pop();
                          onPressed!();
                        }),
                    12.verticalSpace,
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
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack, duration: 500.ms).fadeIn(),
    );
  }
}
