import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  // final bool Function(String) canSubmitCondition;
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

    // required this.canSubmitCondition,
    required this.changeTxt,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final canSubmit = useState(false);
    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          HeaderText(
            text: headerText,
          ),
          20.verticalSpace,
          TitoAdviceWidget(
            text: adviceText,
            isHorizontal: false,
          ),
          20.verticalSpace,
          CustomPinInput(
            pinController: pinController,
            onChanged: () {
              if (error != null) clearError();
              return canSubmit.value = pinController.text.length == 6;
            },
            isError: error != null && error!.isNotEmpty && canSubmit.value,
            isSubmitted: canSubmit.value,
          ),
          const Spacer(),
          if (includeChangeButton)
            CustomTextButton(
              text: changeTxt,
              onPressed: onChangeOtpWayPressed,
              customColor: AppColors.darkBlue,
            ),
          BigButton(
            text: buttonText,
            onPressed: (canSubmit.value && !isLoading)
                ? () => onButtonPressed(
                      pinController.text,
                    )
                : null,
          ),
          DidntReceiveCodeWidget(
            onPressed: onDidntReceiveCode,
            canResend: resendRemainingTime == 0,
          ),
          TimerWidget(
            currentTimeSeconds: resendRemainingTime,
          ),
          0.verticalSpace,
        ],
      ),
    );
  }
}
