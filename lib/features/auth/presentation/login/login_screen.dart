import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/login/google_sign_in_widget.dart';
import 'package:tayssir/features/auth/presentation/login/login_controller.dart';
import 'package:tayssir/features/auth/presentation/widgets/or_widget.dart';

import 'package:tayssir/features/splash/splash_screen.dart';
import 'package:tayssir/providers/auth/auth_notifier.dart';

import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../../../common/tito_advice_widget.dart';
import '../common/auth_button.dart';
import '../common/header_text.dart';
import '../register/widgets/change_auth_type_widget.dart';
import 'custom_text_form_field.dart';
import 'forget_password_button.dart';
import '../../../../utils/validators.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginControllerProvider, (prev, next) {
      next.handleSideThings(context, () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          SnackBarService.showSuccessSnackBar(
            'لقد قمت بتسجيل الدخول بنجاح',
            context: context,
          );
          // context.pop();
        });
      });
    });

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    void seedData() {
      emailController.text = 'fbekkouche141@gmail.com';
      passwordController.text = 'password';
    }

    useEffect(() {
      // seedData();
      return null;
    }, []);

    return AppScaffold(
      paddingB: 0,
      topSafeArea: false,
      resizeToAvoidBottomInset: true,
      // topSafeArea: false,
      body: Form(
        key: formKey,
        child: SliverScrollingWidget(
          children: [
            40.verticalSpace,
            const HeaderText(
              text: AppStrings.login,
            ),
            10.verticalSpace,
            TitoAdviceWidget(
              text: AppStrings.enterCredentials,
              isHorizontal: false,
              size: context.isSmallDevice ? 110.h : 110.h,
            ),
            5.verticalSpace,
            const GoogleSignInWidget(
              isLogin: true,
            ),
            2.0.verticalSpace,
            const OrWidget(),
            2.verticalSpace,

            CustomTextFormField(
              controller: emailController,
              labelText: AppStrings.email,
              validator: Validators.validateEmail,
              prefix: const Icon(Icons.email),
            ),
            10.verticalSpace,
            CustomTextFormField(
              controller: passwordController,
              labelText: AppStrings.password,
              isPassword: true,
              prefix: const Icon(Icons.lock),
              validator: Validators.validatePassword,
            ),
            const ForgetPasswordButton(),
            AuthButton(
              onPressed: ref.watch(loginControllerProvider).isLoading ||
                      ref.watch(authNotifierProvider).isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        ref.read(loginControllerProvider.notifier).login(
                              emailController.text,
                              passwordController.text,
                            );
                      }
                    },
            ),
            if (ref.watch(authNotifierProvider).isLoading)
              Column(
                children: [
                  10.verticalSpace,
                  const TayssirDataLoader(
                    textSize: 14,
                    iconSize: 30,
                  ),
                ],
              ),
            const Spacer(),
            if (context.isSmallDevice) 10.verticalSpace,
            const ChangeAuthTypeWidget(
              isLogin: true,
            ),
            // const SocialRows(),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
