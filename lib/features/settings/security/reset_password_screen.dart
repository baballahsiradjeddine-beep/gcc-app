import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import 'package:tayssir/utils/extensions/context.dart';
import '../../../../../utils/validators.dart';
import '../../auth/presentation/common/header_text.dart';
import '../../auth/presentation/login/custom_text_form_field.dart';
import 'reset_password_controller.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(resetPasswordController);
    final oldPasswordController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final canSubmit = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    void checker() {
      if (oldPasswordController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        canSubmit.value = true;
      } else {
        canSubmit.value = false;
      }
    }

    ref.listen(resetPasswordController, (prev, next) {
      next.handleSideThings(context, () {
        SnackBarService.showSuccessSnackBar(
            AppStrings.passwordChangedSuccessfully, context: context);
      });
    });
    const isKeyboardOpen = false;
    return AppScaffold(
        paddingB: 0,
        resizeToAvoidBottomInset: false,
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
                controller: oldPasswordController,
                labelText: AppStrings.password,
                isPassword: true,
                prefix: const Icon(Icons.lock),
                validator: Validators.validatePassword,
              ),
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
                                .read(resetPasswordController.notifier)
                                .resetPassword(oldPasswordController.text,
                                    passwordController.text);
                          }
                        }
                      : null),
              10.verticalSpace,
            ],
          ),
        ));
  }
}
