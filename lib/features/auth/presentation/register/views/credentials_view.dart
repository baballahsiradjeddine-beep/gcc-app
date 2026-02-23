import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/auth/presentation/login/google_sign_in_widget.dart';
import 'package:tayssir/features/auth/presentation/widgets/or_widget.dart';
import 'package:tayssir/utils/extensions/context.dart';
import 'package:tayssir/utils/validators.dart';
import 'package:tayssir/features/auth/presentation/register/widgets/change_auth_type_widget.dart';

import '../../../../../resources/colors/app_colors.dart';
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

    void seedData() {
      emailController.text = 'fbekkouche149@gmail.com';
      passwordController.text = 'password';
    }

    useEffect(() {
      // seedData();
      return null;
    }, []);
    return AppScaffold(
      paddingY: 0,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        onChanged: () {
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            canSubmit.value = true;
          } else {
            canSubmit.value = false;
          }
        },
        child: SliverScrollingWidget(
          children: [
            10.verticalSpace,
            const HeaderText(text: AppStrings.createAccount),
            10.verticalSpace,
            TitoAdviceWidget(
              text: AppStrings.enterCredentials,
              isHorizontal: false,
              size: context.isSmallDevice ? 110.h : 110.h,
            ),            5.verticalSpace,
            const GoogleSignInWidget(
              isLogin: false,
            ),
            2.verticalSpace,
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
            10.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                child: Text(
                  AppStrings.passwordAdvice,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            20.verticalSpace,
            AuthButton(
              isLogin: false,
              onPressed: registerController.value.isLoading || !canSubmit.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(registerControllerProvider.notifier)
                            .setCredentials(
                              emailController.text,
                              passwordController.text,
                            );

                        // emailController.clear();
                        // passwordController.clear();
                      }
                    },
            ),
            const Spacer(),
            const ChangeAuthTypeWidget(),
            // const SocialRows(
            //   isLogin: false,
            // ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
