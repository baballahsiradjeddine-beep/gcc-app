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
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

import '../../../../../resources/colors/app_colors.dart';
import '../../../../../utils/validators.dart';
import '../../common/header_text.dart';

class EnterPhoneNumberView extends HookConsumerWidget {
  const EnterPhoneNumberView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgetPasswordControllerProvider);
    final emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(true);
    ref.listen(forgetPasswordControllerProvider.select((val) => val.status),
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
                text: AppStrings.changingPassword,
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
                              .read(forgetPasswordControllerProvider.notifier)
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
