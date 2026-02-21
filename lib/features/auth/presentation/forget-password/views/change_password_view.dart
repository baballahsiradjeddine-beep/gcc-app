import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/forget-password/forget_password_controller.dart';
import 'package:tayssir/utils/extensions/context.dart';
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
      if (passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        canSubmit.value = true;
      } else {
        canSubmit.value = false;
      }
    }

    const isKeyboardOpen = false;
    return AppScaffold(
        paddingB: 0,
        resizeToAvoidBottomInset: true,
        body: Form(
          key: formKey,
          onChanged: checker,
          child: SliverScrollingWidget(
            children: [
              const HeaderText(
                text: AppStrings.changingPassword,
              ),
              10.verticalSpace,
              !isKeyboardOpen
                  ? TitoAdviceWidget(
                      text: AppStrings.enterCredentials,
                      isHorizontal: false,
                      size: context.isSmallDevice ? 150.h : 180.h,
                    )
                  : const SizedBox.shrink(),
              20.verticalSpace,
              CustomTextFormField(
                controller: passwordController,
                labelText: AppStrings.password,
                isPassword: true,
                prefix: const Icon(Icons.lock),
                validator: Validators.validatePassword,
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CustomTextFormField(
                  controller: confirmPasswordController,
                  labelText: AppStrings.confirmPassword,
                  isPassword: true,
                  prefix: const Icon(Icons.lock),
                  validator: (value) => Validators.validateConfirmPassword(
                      value, passwordController.text),
                ),
              ),
              const Spacer(),
              BigButton(
                  text: AppStrings.check,
                  onPressed: canSubmit.value && !controller.isLoading
                      ? () {
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(forgetPasswordControllerProvider.notifier)
                                .changeForgetPassword(passwordController.text);
                          }
                        }
                      : null),
              10.verticalSpace,
            ],
          ),
        ));
  }
}
