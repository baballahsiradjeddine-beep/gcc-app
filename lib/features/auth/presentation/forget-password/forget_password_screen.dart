import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/auth/presentation/forget-password/views/forget_password_otp_code_view.dart';

import 'forget_password_controller.dart';
import 'views/change_password_view.dart';
import 'views/forget_password_success_view.dart';
import 'views/enter_email_view.dart';

class ForgetPasswordView extends HookConsumerWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgetPasswordControllerProvider);
    return PageView(
      controller: controller.pageController,
      // physics: const NeverScrollableScrollPhysics(),
      children: const [
        EnterPhoneNumberView(),
        ForgetPasswordOtpVodeView(),
        ChangePasswordView(),
        ForgetPasswordSuccessView(),
      ],
    );
  }
}
