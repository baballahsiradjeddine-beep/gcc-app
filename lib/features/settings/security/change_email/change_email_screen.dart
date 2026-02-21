import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/presentation/common/header_text.dart';
import 'package:tayssir/features/auth/presentation/common/otp_code_view.dart';
import 'package:tayssir/features/auth/presentation/common/tayssir_success_view.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_controller.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_otp_code_view.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_success_view.dart';
import 'package:tayssir/features/settings/security/change_email/enter_email_view.dart';


class ChangeEmailScreen extends HookConsumerWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changeEmailControllerProvider);
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        EnterEmailView(),
        ChangeEmailOtpCodeView(),
        ChangeEmailSuccessView(),
      ],
    );
  }
}
