import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';
import 'package:tayssir/features/auth/presentation/register/state/otp_type.dart';

import '../../../../../exceptions/app_exception.dart';
import '../state/register_controller.dart';

// TODO: CAN combine this into single one for phone and email otp code view and just provide the otp type
class PhoneVerifyOtpCodeView extends HookConsumerWidget {
  const PhoneVerifyOtpCodeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);

    return OtpCodeView(
      headerText: AppStrings.verifyPhoneNumber,
      adviceText: AppStrings.enterCredentials,
      buttonText: AppStrings.check,
      changeTxt: AppStrings.changePhoneNumber,
      resendRemainingTime: registerController.verifyState.resendRemainingTime,
      onButtonPressed: (pin) {
        ref
            .read(registerControllerProvider.notifier)
            .verifyOtp(pin, OtpType.phone);
      },
      onDidntReceiveCode: () {
        ref.read(registerControllerProvider.notifier).resendOtpCode(
              otpType: OtpType.phone,
            );
      },
      onChangeOtpWayPressed: () {
        ref.read(registerControllerProvider.notifier).resetOtpOption(
              otpType: OtpType.phone,
            );
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
