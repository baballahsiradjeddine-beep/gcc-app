import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/forget-password/forget_password_controller.dart';
import '../../../../../utils/validators.dart';
import '../../common/header_text.dart';
import '../../login/custom_text_form_field.dart';

class ChangePasswordView extends HookConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgetPasswordControllerProvider);
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final canSubmit = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    void checker() {
      canSubmit.value = passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    }

    return AppScaffold(
      paddingB: 0,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        onChanged: checker,
        child: SliverScrollingWidget(
          children: [
            24.verticalSpace,
            const HeaderText(text: AppStrings.changingPassword)
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            const TitoAdviceWidget(
              text: "قم بتعيين كلمة سر جديدة لحسابك",
              isHorizontal: false,
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            CustomTextFormField(
              controller: passwordController,
              labelText: "كلمة السر الجديدة",
              isPassword: true,
              prefix: const Icon(Icons.lock_reset_rounded),
              validator: Validators.validatePassword,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
            
            20.verticalSpace,
            
            CustomTextFormField(
              controller: confirmPasswordController,
              labelText: "تأكيد كلمة السر",
              isPassword: true,
              prefix: const Icon(Icons.check_circle_outline_rounded),
              validator: (value) => Validators.validateConfirmPassword(
                  value, passwordController.text),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
            
            60.verticalSpace,
            
            BigButton(
              text: "تحديث كلمة السر",
              onPressed: canSubmit.value && !controller.isLoading
                  ? () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(forgetPasswordControllerProvider.notifier)
                            .changeForgetPassword(passwordController.text);
                      }
                    }
                  : null,
            ).animate().fadeIn(delay: 500.ms).scale(),
            
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
