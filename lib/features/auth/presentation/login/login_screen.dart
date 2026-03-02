import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        });
      });
    });

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingB: 0,
      topSafeArea: true,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: SliverScrollingWidget(
          children: [
            24.verticalSpace,
            // Main Title
            const HeaderText(text: AppStrings.login)
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            // Tito Welcome Area
            const TitoAdviceWidget(
              text: "قم بإدخال بياناتك",
              isHorizontal: false, // Use vertical layout as in HTML
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            // Auth Methods
            const GoogleSignInWidget(isLogin: true)
                .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const OrWidget().animate().fadeIn(delay: 300.ms),
            
            // Input Fields
            CustomTextFormField(
              controller: emailController,
              labelText: AppStrings.email,
              hintText: "example@email.com",
              validator: Validators.validateEmail,
              prefix: const Icon(Icons.alternate_email_rounded),
            ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
            
            20.verticalSpace,
            
            CustomTextFormField(
              controller: passwordController,
              labelText: AppStrings.password,
              hintText: "********",
              isPassword: true,
              prefix: const Icon(Icons.lock_outline_rounded),
              validator: Validators.validatePassword,
            ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
            
            12.verticalSpace,
            
            // Forgot Password Link
            const Align(
              alignment: Alignment.centerRight,
              child: ForgetPasswordButton(),
            ).animate().fadeIn(delay: 600.ms),
            
            32.verticalSpace,
            
            // Action Button
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
            ).animate().fadeIn(delay: 700.ms).scale(),
            
            if (ref.watch(authNotifierProvider).isLoading)
              Column(
                children: [
                  24.verticalSpace,
                  const TayssirDataLoader(
                    textSize: 14,
                    iconSize: 32,
                  ),
                ],
              ),
            
            40.verticalSpace,
            
            // Toggle Login/Register
            const ChangeAuthTypeWidget(isLogin: true)
                .animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
            
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
