import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/tayssir_success_view.dart';

class ChangeEmailSuccessView extends HookConsumerWidget {
  const ChangeEmailSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TayssirSuccessView(
      title: AppStrings.changeEmail,
      titoText: AppStrings.emailChangedSuccessfully,
      onPressed: () {
        context.pop();
      },
    );
  }
}
