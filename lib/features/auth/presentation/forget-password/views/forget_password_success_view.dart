import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/tayssir_success_view.dart';

import '../../../../../router/app_router.dart';

class ForgetPasswordSuccessView extends HookConsumerWidget {
  const ForgetPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TayssirSuccessView(
      title: AppStrings.changingPassword,
      titoText: AppStrings.passwordChangedSuccessfully,
      onPressed: () {
        context.goNamed(
          AppRoutes.login.name,
        );
      },
    );
  }
}
