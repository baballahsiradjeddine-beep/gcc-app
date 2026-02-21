import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/constants/strings.dart' show AppStrings, login;
import 'package:tayssir/features/auth/presentation/common/tayssir_success_view.dart';
import 'package:tayssir/features/auth/presentation/verify-email/state/verify_email_controller.dart';
import 'package:tayssir/providers/token/token_controller.dart';
import 'package:tayssir/router/app_router.dart';

class VerifyEmailIntroView extends ConsumerWidget {
  const VerifyEmailIntroView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TayssirSuccessView(
      title: AppStrings.verifyEmailMessage,
      titoText: AppStrings.verifyEmailSubMessage,
      buttonText: AppStrings.send,
      isLoading: ref.watch(verifyEmailControllerProvider).status.isLoading,
      onPressed: () {
        ref.read(verifyEmailControllerProvider.notifier).onStart();
      },
      subPress: () {
        // ref.read(verifyEmailControllerProvider.notifier).onChangeEmail();
        //logout
        ref.read(tokenProvider.notifier).clearToken();
        context.goNamed(AppRoutes.welcome.name);
      },
      onSubPressed: () {
        ref.read(verifyEmailControllerProvider.notifier).haveCode();
      },
    );
  }
}
