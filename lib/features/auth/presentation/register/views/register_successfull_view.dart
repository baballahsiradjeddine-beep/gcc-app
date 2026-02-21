import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_logo.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/auth/presentation/register/state/register_controller.dart';
import 'package:tayssir/features/splash/splash_screen.dart';
import 'package:tayssir/providers/auth/auth_notifier.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

import '../../../../../common/app_buttons/big_button.dart';
import '../../../../../common/core/app_scaffold.dart';
import '../../../../../constants/strings.dart';
import '../../../../../common/tito_advice_widget.dart';

class RegisterSuccessfullView extends ConsumerWidget {
  const RegisterSuccessfullView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(registerControllerProvider.select((v) => v.value), (prev, next) {
      next.handleSideThings(context, () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          SnackBarService.showSuccessSnackBar(
            'لقد قمت بإنشاء حسابك بنجاح',
            context: context,
          );
          // context.pop();
        });
      });
    });
    return AppScaffold(
      body: SliverScrollingWidget(
        children: [
          const AppLogo(),
          20.verticalSpace,
          const TitoAdviceWidget(
            text: AppStrings.registerMessage,
            isHorizontal: false,
          ),
          20.verticalSpace,
          Text(AppStrings.titoTalk,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.spMin,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
          const Spacer(),
          BigButton(
            text: AppStrings.continueText,
            onPressed: ref.watch(registerControllerProvider).isLoading ||
                    ref.watch(authNotifierProvider).isLoading
                ? null
                : () {
                    ref
                        .read(registerControllerProvider.notifier)
                        .fullRegister();
                  },
          ),
          if (ref.watch(authNotifierProvider).isLoading)
            Column(
              children: [
                10.verticalSpace,
                const TayssirDataLoader(
                  textSize: 14,
                  iconSize: 30,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
