import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/auth/presentation/login/google_sign_in_widget.dart';
import 'package:tayssir/features/auth/presentation/widgets/or_widget.dart';
import 'package:tayssir/utils/validators.dart';
import 'package:tayssir/features/auth/presentation/register/widgets/change_auth_type_widget.dart';
import '../../common/auth_button.dart';
import '../../common/header_text.dart';
import '../state/register_controller.dart';

class RegisterCredentialsView extends HookConsumerWidget {
  const RegisterCredentialsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerController = ref.watch(registerControllerProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingY: 0,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        onChanged: () {
          canSubmit.value = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
        },
        child: SliverScrollingWidget(
          children: [
            24.verticalSpace,
            const HeaderText(text: AppStrings.createAccount)
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            const TitoAdviceWidget(
              text: "قم بتسجيل حسابك الجديد",
              isHorizontal: false,
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            const GoogleSignInWidget(isLogin: false)
                .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const OrWidget().animate().fadeIn(delay: 300.ms),
            
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
            
            16.verticalSpace,
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppStrings.passwordAdvice,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: const Color(0xFF00B4D8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                  letterSpacing: 0.2,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
            
            32.verticalSpace,
            
            AuthButton(
              isLogin: false,
              onPressed: registerController.value.isLoading || !canSubmit.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        ref.read(registerControllerProvider.notifier).setCredentials(
                              emailController.text,
                              passwordController.text,
                            );
                      }
                    },
            ).animate().fadeIn(delay: 700.ms).scale(),
            
            40.verticalSpace,
            
            const ChangeAuthTypeWidget(isLogin: false)
                .animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
            
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
