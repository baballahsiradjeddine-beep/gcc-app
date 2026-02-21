import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import 'views/credentials_view.dart';
import 'views/know_us_view.dart';
import 'views/personal_informations_screen.dart';
import 'state/register_controller.dart';
import 'views/register_successfull_view.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);
    ref.listen(
        registerControllerProvider.select(
          (state) => state.value,
        ), (prv, curr) {
      if (curr is AsyncError) {
        curr.handleSideThings(context, () {});
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
                  controller: registerController.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {},
                  children: const [
                    RegisterCredentialsView(),
                    // EmailVerifyOtpCodeView(),
                    PersonalInformationsView(),
                    // PhoneVerifyOtpCodeView(),
                    KnowUsView(),
                    RegisterSuccessfullView(),
                    // SubscriptionScreen()
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
