// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/subscriptions/data/subscription_repository.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/subscription_paper_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/widgets/subscription_option.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/router/app_router.dart';

import '../../../common/app_buttons/big_button.dart';
import '../../../common/core/app_scaffold.dart';
import '../../../common/tito_advice_widget.dart';
import '../../../constants/strings.dart';

final subscriptionOptionsProvider =
    FutureProvider<List<SubscriptionModel>>((ref) async {
  final data =
      await ref.watch(subscriptionRepositoryProvider).getSubscriptions();

  return data;
});

class SubscriptionOptionsScreen extends HookConsumerWidget {
  const SubscriptionOptionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionOptionsAsync = ref.watch(subscriptionOptionsProvider);
    final selectedSubOption = useState<SubscriptionModel?>(null);

    return AppScaffold(
      paddingY: 0,
      topSafeArea: false,
      body: subscriptionOptionsAsync.when(
        data: (subscriptionOptions) {
          // Set initial selection if not set
          if (selectedSubOption.value == null &&
              subscriptionOptions.isNotEmpty) {
            selectedSubOption.value = subscriptionOptions.first;
          }

          return SliverScrollingWidget(
            children: [
              50.verticalSpace,
              const CustomBackButton(),
              const TitoAdviceWidget(
                  text: AppStrings.dearStudentChooseSubscription),
              10.verticalSpace,
              ...List.generate(
                subscriptionOptions.length,
                (index) => SubscriptionOptionWidget(
                  totalPrice: subscriptionOptions[index].price,
                  discountedPrice:
                      subscriptionOptions[index].discounts.isNotEmpty
                          ? subscriptionOptions[index].realPrice
                          : null,
                  percentageDiscount:
                      subscriptionOptions[index].discounts.isNotEmpty
                          ? subscriptionOptions[index].percentage
                          : null,
                  descriptionText: subscriptionOptions[index].description,
                  gradientColors: subscriptionOptions[index].gradientColors,
                  innerColor: subscriptionOptions[index].innterColor,
                  onPressed: () {
                    if (selectedSubOption.value != subscriptionOptions[index]) {
                      selectedSubOption.value = subscriptionOptions[index];
                    }
                  },
                  disabledColor: const Color(0xffEEEEEE),
                  isSelected:
                      (selectedSubOption.value == subscriptionOptions[index]),
                ),
              ),
              const Spacer(),
              BigButton(
                text: AppStrings.continueText,
                onPressed: selectedSubOption.value != null
                    ? () {
                        context.pushNamed(AppRoutes.subscriptions.name,
                            extra: {'subscription': selectedSubOption.value});
                      }
                    : null,
              ),
              20.verticalSpace,
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              16.verticalSpace,
              Text('Error loading subscriptions: $error'),
              16.verticalSpace,
              ElevatedButton(
                onPressed: () => ref.refresh(subscriptionOptionsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
