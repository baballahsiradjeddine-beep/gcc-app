import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import '../../../../common/app_buttons/big_button.dart';
import '../../../../common/app_buttons/custom_text_button.dart';
import '../../../../common/core/app_scaffold.dart';
import '../../../../common/forms/custom_pin_input.dart';
import '../../../../common/tito_advice_widget.dart';
import 'header_text.dart';
import '../forget-password/timer_widget.dart';
import '../forget-password/widgets/didnt_receive_code_widget.dart';

class OtpCodeView extends HookConsumerWidget {
  final String headerText;
  final String adviceText;
  final String buttonText;
  final int resendRemainingTime;
  final Function(String) onButtonPressed;
  final VoidCallback onChangeOtpWayPressed;
  final VoidCallback onDidntReceiveCode;
  final VoidCallback clearError;
  final String changeTxt;
  final String? error;
  final bool isLoading;
  final bool includeChangeButton;

  const OtpCodeView({
    super.key,
    required this.headerText,
    required this.adviceText,
    required this.buttonText,
    required this.resendRemainingTime,
    required this.onButtonPressed,
    required this.onChangeOtpWayPressed,
    required this.onDidntReceiveCode,
    required this.clearError,
    this.isLoading = false,
    this.includeChangeButton = true,
    required this.changeTxt,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final canSubmit = useState(false);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          24.verticalSpace,
          HeaderText(text: headerText)
              .animate().fadeIn().slideY(begin: -0.1, end: 0),
          
          32.verticalSpace,
          
          TitoAdviceWidget(
            text: adviceText,
            isHorizontal: false,
          ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
          
          48.verticalSpace,
          
          CustomPinInput(
            pinController: pinController,
            onChanged: () {
              if (error != null) clearError();
              canSubmit.value = pinController.text.length == 6;
            },
            isError: error != null && error!.isNotEmpty && canSubmit.value,
            isSubmitted: canSubmit.value,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
          
          40.verticalSpace,
          
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withOpacity(0.5) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  TimerWidget(currentTimeSeconds: resendRemainingTime),
                  8.verticalSpace,
                  DidntReceiveCodeWidget(
                    onPressed: onDidntReceiveCode,
                    canResend: resendRemainingTime == 0,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
          
          60.verticalSpace,
          
          if (includeChangeButton)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: BigButton(
                buttonType: ButtonType.secondary,
                text: changeTxt,
                onPressed: onChangeOtpWayPressed,
              ),
            ).animate().fadeIn(delay: 500.ms),
          
          BigButton(
            text: buttonText,
            onPressed: (canSubmit.value && !isLoading)
                ? () => onButtonPressed(pinController.text)
                : null,
          ).animate().fadeIn(delay: 600.ms).scale(),
          
          40.verticalSpace,
        ],
      ),
    );
  }
}
