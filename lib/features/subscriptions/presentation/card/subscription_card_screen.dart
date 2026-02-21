// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/subscriptions/presentation/card/subscribe_card_button.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/features/subscriptions/presentation/state/subscription_controller.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

import '../../../../common/app_buttons/big_button.dart';
import '../../../../common/core/app_scaffold.dart';
import '../../../../common/tito_advice_widget.dart';
import '../../../../constants/strings.dart';
import '../../../../exceptions/app_exception.dart';
import '../../../../router/app_router.dart';

class SubscriptionCardScreen extends HookConsumerWidget {
  const SubscriptionCardScreen({super.key, required this.subscription});
  final SubscriptionModel subscription;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardNumberController = useTextEditingController();
    final isValid = useState<bool>(false);
    final shouldShowError =
        ref.watch(subscriptionControllerProvider).state is AsyncError;
    cardNumberController.addListener(
      () {
        if (cardNumberController.text.length == 12) {
          isValid.value = true;
        } else {
          isValid.value = false;
        }
      },
    );

    ref.listen(subscriptionControllerProvider.select((v) => v.state),
        (prv, nxt) {
      nxt.handleSideThings(context, () {
        DialogService.showSubscriptionDoneDialog(context, () {
          context.goNamed(AppRoutes.home.name);
        });
      }, shouldShowError: false);
    });

    seedData() {
      cardNumberController.text = '638653358501';
    }

    useEffect(() {
      // seedData();
      return null;
    }, []);

    return AppScaffold(
      paddingY: 0,
      topSafeArea: false,
      body: SliverScrollingWidget(
        children: [
          50.verticalSpace,
          const CustomBackButton(),
          const TitoAdviceWidget(text: AppStrings.goodChoice),
          10.verticalSpace,
          SubscribeCardButton(
            controller: cardNumberController,
            hasError: shouldShowError,
            price: subscription.realPrice,
            //369677132134
          ),
          10.verticalSpace,
          // error message
          shouldShowError
              ? Text(
                  (ref
                          .watch(subscriptionControllerProvider)
                          .state
                          .asError!
                          .error as AppException)
                      .message
                      .toString(),
                  style: const TextStyle(color: Colors.red),
                )
              : const SizedBox(),
          const Spacer(),
          BigButton(
            text: AppStrings.check,
            onPressed: isValid.value &&
                    !ref.watch(subscriptionControllerProvider).state.isLoading
                ? () {
                    ref
                        .read(subscriptionControllerProvider.notifier)
                        .subscribeWithCard(
                            cardNumberController.text, subscription);
                  }
                : null,
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
