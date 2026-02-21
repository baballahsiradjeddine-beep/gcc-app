import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/header_text.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_controller.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import 'package:tayssir/utils/validators.dart';

class EnterEmailView extends HookConsumerWidget {
  const EnterEmailView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changeEmailControllerProvider);
    final emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);

    emailController.addListener(
      () {
        if (emailController.text.isNotEmpty) {
          canSubmit.value = true;
        } else {
          canSubmit.value = false;
        }
      },
    );
    ref.listen(changeEmailControllerProvider.select((val) => val.status),
        (prv, curr) {
      if (curr is AsyncError) {
        curr.handleSideThings(context, () {});
      }
    });
    return AppScaffold(
        paddingB: 0,
        body: Form(
          key: formKey,
          onChanged: () {
            if (emailController.text.isNotEmpty) {
              canSubmit.value = true;
            } else {
              canSubmit.value = false;
            }
          },
          child: SliverScrollingWidget(
            children: [
              const HeaderText(
                text: AppStrings.changeEmail,
              ),
              10.verticalSpace,
              const TitoAdviceWidget(
                text: AppStrings.enterCredentials,
                isHorizontal: false,
              ),
              10.verticalSpace,
              CustomTextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  labelText: AppStrings.email,
                  prefix: const Icon(Icons.email)),
              20.verticalSpace,
              Text(AppStrings.forgetPasswordAdvice,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              BigButton(
                text: AppStrings.continueText,
                onPressed: (!canSubmit.value || controller.isLoading)
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(changeEmailControllerProvider.notifier)
                              .onEmailEntered(emailController.text);
                        }
                      },
              ),
              10.verticalSpace,
            ],
          ),
        ));
  }
}
