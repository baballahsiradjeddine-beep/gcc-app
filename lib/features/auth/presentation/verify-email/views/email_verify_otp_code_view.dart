import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';
import 'package:tayssir/features/auth/presentation/verify-email/state/verify_email_controller.dart';

class EmailVerifyOtpCodeView extends ConsumerWidget {
  const EmailVerifyOtpCodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(verifyEmailControllerProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: OtpCodeView(
          headerText: AppStrings.verifyEmail,
          adviceText: AppStrings.enterCredentials,
          buttonText: AppStrings.check,
          changeTxt: AppStrings.changeEmail,
          resendRemainingTime: controller.verifyState.resendRemainingTime,
          includeChangeButton: false,
          onButtonPressed: (pin) {
            // ref
            //     .read(registerControllerProvider.notifier)
            //     .verifyOtp(pin, OtpType.email);
            ref.read(verifyEmailControllerProvider.notifier).verifyOtp(pin);
          },
          onDidntReceiveCode: () {
            // ref.read(emailVerifyControllerProvider.notifier).resendOtpCode();
            // ref
            //     .read(registerControllerProvider.notifier)
            //     .resendOtpCode(otpType: OtpType.email);
            ref.read(verifyEmailControllerProvider.notifier).resendOtpCode();
          },
          onChangeOtpWayPressed: () {},
          clearError: () {
            // ref.read(registerControllerProvider.notifier).clearError();
            ref.read(verifyEmailControllerProvider.notifier).clearError();
          },
          // error: registerController.value.hasError
          //     ? (registerController.value.error as AppException).message
          //     : null,
          error: controller.status.hasError
              ? (controller.status.error as Exception).toString()
              : null,
        ),
      ),
    );
  }
}
