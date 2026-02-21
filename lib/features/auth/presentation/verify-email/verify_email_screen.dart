import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/features/auth/presentation/verify-email/state/verify_email_controller.dart';
import 'package:tayssir/features/auth/presentation/verify-email/views/email_verify_otp_code_view.dart';
import 'package:tayssir/features/auth/presentation/verify-email/views/verify_email_intro_view.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

class VerifyEmailScreen extends HookConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(verifyEmailControllerProvider);
    ref.listen(
        verifyEmailControllerProvider.select(
          (state) => state.status,
        ), (prv, curr) {
      curr.handleSideThings(context, () {});
    });

    ref.listen(verifyEmailControllerProvider.select((s) => s.isCompleted),
        (previous, next) {
      if (next == true && previous == false) {
        SnackBarService.showSuccessSnackBar(
            "تم التحقق من البريد الإلكتروني بنجاح",
            context: context);
        // Navigator.of(context).pop();
      }
    });
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {},
                  children: const [
                    VerifyEmailIntroView(),
                    EmailVerifyOtpCodeView(),
                  ],
                ),
              ),
              10.verticalSpace,
            ],
          )),
    );
  }
}
