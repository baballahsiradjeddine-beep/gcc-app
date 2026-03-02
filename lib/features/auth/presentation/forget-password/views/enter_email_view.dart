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
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/utils/extensions/async_value.dart';
import '../../../../../utils/validators.dart';
import '../../common/header_text.dart';

class EnterPhoneNumberView extends HookConsumerWidget {
  const EnterPhoneNumberView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgetPasswordControllerProvider);
    final emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          canSubmit.value = emailController.text.isNotEmpty;
        },
        child: SliverScrollingWidget(
          children: [
            24.verticalSpace,
            const HeaderText(text: AppStrings.changingPassword)
                .animate().fadeIn().slideY(begin: -0.1, end: 0),
            
            32.verticalSpace,
            
            const TitoAdviceWidget(
              text: AppStrings.enterCredentials,
              isHorizontal: false,
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
            
            40.verticalSpace,
            
            CustomTextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
              labelText: AppStrings.email,
              hintText: "example@email.com",
              prefix: const Icon(Icons.alternate_email_rounded),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
            
            24.verticalSpace,
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                AppStrings.forgetPasswordAdvice,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SomarSans',
                  height: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            60.verticalSpace,
            
            BigButton(
              text: "إرسال رابط الإستعادة",
              onPressed: (!canSubmit.value || controller.isLoading)
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(forgetPasswordControllerProvider.notifier)
                            .onEmailEntered(emailController.text);
                      }
                    },
            ).animate().fadeIn(delay: 600.ms).scale(),
            
            24.verticalSpace,
            
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "العودة لتسجيل الدخول",
                style: TextStyle(
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
            ).animate().fadeIn(delay: 700.ms),
            
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
