import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';
import 'package:tayssir/features/auth/presentation/register/state/otp_type.dart';

import '../state/register_controller.dart';

class EmailVerifyOtpCodeView extends HookConsumerWidget {
  const EmailVerifyOtpCodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);

    return OtpCodeView(
      headerText: AppStrings.verifyEmail,
      adviceText: AppStrings.enterCredentials,
      buttonText: AppStrings.check,
      changeTxt: AppStrings.changeEmail,
      resendRemainingTime: registerController.verifyState.resendRemainingTime,
      onButtonPressed: (pin) {
        ref
            .read(registerControllerProvider.notifier)
            .verifyOtp(pin, OtpType.email);
      },
      onDidntReceiveCode: () {
        // ref.read(emailVerifyControllerProvider.notifier).resendOtpCode();
        ref
            .read(registerControllerProvider.notifier)
            .resendOtpCode(otpType: OtpType.email);
      },
      onChangeOtpWayPressed: () {
        ref.read(registerControllerProvider.notifier).resetOtpOption();
      },
      clearError: () {
        ref.read(registerControllerProvider.notifier).clearError();
      },
      error: registerController.value.hasError
          ? (registerController.value.error as AppException).message
          : null,
    );
  }
}
