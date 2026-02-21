import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_controller.dart';

class ChangeEmailOtpCodeView extends HookConsumerWidget {
  const ChangeEmailOtpCodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changeEmailControllerProvider);

    return OtpCodeView(
      headerText: AppStrings.changeEmail,
      adviceText: AppStrings.enterCredentials,
      buttonText: AppStrings.check,
      resendRemainingTime: controller.remainingTime,
      clearError: () {
        ref.read(changeEmailControllerProvider.notifier).clearError();
      },
      onButtonPressed: (pin) {
        ref.read(changeEmailControllerProvider.notifier).verifyOtpCode(pin);
      },
      onDidntReceiveCode: () {
        ref.read(changeEmailControllerProvider.notifier).resendOtpCode();
      },
      isLoading: controller.isLoading,
      onChangeOtpWayPressed: () {
        ref.read(changeEmailControllerProvider.notifier).changeEmail();
      },
      changeTxt: AppStrings.changeEmail,
      error: controller.status.hasError
          ? (controller.status.error as AppException).message
          : null,
    );
  }
}
