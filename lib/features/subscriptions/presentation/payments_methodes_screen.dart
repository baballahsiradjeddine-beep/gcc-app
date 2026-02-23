// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/subscriptions/domaine/payement_model.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/features/subscriptions/presentation/widgets/subscription_option.dart';

import '../../../common/app_buttons/big_button.dart';
import '../../../common/core/app_scaffold.dart';
import '../../../common/tito_advice_widget.dart';
import '../../../constants/strings.dart';
import '../../../providers/user/subscription_model.dart';
import '../../auth/presentation/register/widgets/option_selection.dart';
import 'state/subscription_controller.dart';

class SubscriptionsScreen extends HookConsumerWidget {
  const SubscriptionsScreen({super.key, required this.subscription});

  final SubscriptionModel subscription;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payementsMethodes = ref.watch(paymentsMethodesProvider);
    final selectedPayementMethode =
        useState<PayementModel>(payementsMethodes.first);

    return AppScaffold(
      paddingY: 0,
      topSafeArea: false,
      body: SliverScrollingWidget(
        children: [
          50.verticalSpace,
          const CustomBackButton(),
          const TitoAdviceWidget(text: AppStrings.titoSubscription),
          10.verticalSpace,
          SubscriptionOptionWidget(
            totalPrice: subscription.realPrice,
            descriptionText: subscription.description,
            gradientColors: subscription.gradientColors,
            innerColor: subscription.innterColor,
            onPressed: () {},
            isSelected: true,
          ),
          10.verticalSpace,
          ...List.generate(
            payementsMethodes.length,
            (index) => OptionSelection(
              iconPath: payementsMethodes[index].icon,
              text: payementsMethodes[index].value,
              onPressed: () {
                selectedPayementMethode.value = payementsMethodes[index];
              },
              isSelected:
                  selectedPayementMethode.value == payementsMethodes[index],
            ),
          ),
          const Spacer(),
          BigButton(
            text: AppStrings.continueText,
            onPressed: () {
              context.pushNamed(selectedPayementMethode.value.path, extra: {
                'subscription': subscription,
              });
            },
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
