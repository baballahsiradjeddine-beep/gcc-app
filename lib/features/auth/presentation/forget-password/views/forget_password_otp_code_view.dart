import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/forget-password/forget_password_controller.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';

import '../../../../../exceptions/app_exception.dart';

class ForgetPasswordOtpVodeView extends HookConsumerWidget {
  const ForgetPasswordOtpVodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgetPasswordControllerProvider);

    return OtpCodeView(
      headerText: AppStrings.changingPassword,
      adviceText: AppStrings.enterCredentials,
      buttonText: AppStrings.check,
      resendRemainingTime: controller.remainingTime,
      clearError: () {
        ref.read(forgetPasswordControllerProvider.notifier).clearError();
      },
      onButtonPressed: (pin) {
        ref.read(forgetPasswordControllerProvider.notifier).verifyOtpCode(pin);
      },
      onDidntReceiveCode: () {
        ref.read(forgetPasswordControllerProvider.notifier).resendOtpCode();
      },
      isLoading: controller.isLoading,
      onChangeOtpWayPressed: () {
        ref.read(forgetPasswordControllerProvider.notifier).changeEmail();
      },
      changeTxt: AppStrings.changePhoneNumber,
      error: controller.status.hasError
          ? (controller.status.error as AppException).message
          : null,
    );
  }
}
