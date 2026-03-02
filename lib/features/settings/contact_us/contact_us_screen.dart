import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/login/custom_text_form_field.dart';
import 'package:tayssir/features/settings/contact_us/contact_us_controller.dart';
import 'package:tayssir/features/settings/domaine/contact_us_model.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

class ContactUsScreen extends HookConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final canSubmit = useState(false);
    final user = ref.watch(userNotifierProvider).valueOrNull;
    final emailController = useTextEditingController(
      text: user?.email ?? '',
    );
    final fullNameController = useTextEditingController(
      text: user?.name ?? '',
    );
    final messageController = useTextEditingController();

    final messageFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final fullNameFocusNode = useFocusNode();

    // * this is good and can be reused and extracted to a custom hook
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    useEffect(() {
      if (!isKeyboardOpen) {
        messageFocusNode.unfocus();
        emailFocusNode.unfocus();
        fullNameFocusNode.unfocus();
      }
      return null;
    }, [isKeyboardOpen]);
    // *  end of custom hook
    ref.listen(contactUsControllerProvider, (prv, next) {
      next.handleSideThings(context, () {
        SnackBarService.showSuccessToast('تم إرسال الملاحظات');
        messageController.clear();
      });
    }
        // onData: () {
        //   // SnackBarService.showSuccessToast('Form Submitted', null);
        //   // DialogService.showContactUsDialog(context);
        //   context.pushNamed(
        //     AppRoutes.contactUsSuccess.name,
        //   );
        // },
        );
    return AppScaffold(
        // formKey: formKey,
        resizeToAvoidBottomInset: true,
        paddingB: isKeyboardOpen ? 0 : 20,
        // backgroundType: BackgroundType.light,
        // onFormChanged: () => canSubmit.value =
        //     messageController.text.isNotEmpty &&
        //         emailController.text.isNotEmpty &&
        //         fullNameController.text.isNotEmpty,
        body: Form(
          key: formKey,
          onChanged: () => canSubmit.value =
              messageController.text.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  fullNameController.text.isNotEmpty,
          child: SliverScrollingWidget(children: [
            const CustomBackButton(),
            20.verticalSpace,
            SizedBox(
              width: 0.9.sw,
              child: Text(
                AppStrings.contactUsTitle,
                // textAlign: TextAlign.,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                  height: 1.4,
                ),
              ),
            ),
            20.verticalSpace,
            CustomTextFormField(
              prefix: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 14.r,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              controller: fullNameController,
              labelText: AppStrings.fullName,
              // externalFocusNode: fullNameFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            10.verticalSpace,
            CustomTextFormField(
              prefix: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 14.r,
                child: const Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              controller: emailController,
              labelText: AppStrings.email,
              // externalFocusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            10.verticalSpace,
            CustomTextFormField(
              controller: messageController,
              labelText: AppStrings.enterMessage,
              isMultiLine: true,
              // externalFocusNode: messageFocusNode,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
            ),
            const Spacer(),
            if (isKeyboardOpen) 20.verticalSpace,
            BigButton(
              text: AppStrings.submit,
              // shouldExpand: true,
              // canSubmit: canSubmit.value,
              onPressed: ref.watch(contactUsControllerProvider).isLoading &&
                      canSubmit.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(contactUsControllerProvider.notifier)
                            .sendContactUs(ContactUsModel(
                                email: emailController.text,
                                name: fullNameController.text,
                                message: messageController.text));
                      }
                    },
            )
          ]),
        ));
  }
}
