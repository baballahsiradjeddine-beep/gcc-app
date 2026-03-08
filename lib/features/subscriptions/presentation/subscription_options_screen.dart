// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/subscriptions/data/subscription_repository.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/features/subscriptions/presentation/widgets/subscription_option.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/common/core/app_scaffold.dart';

import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingX: 20.w,
      appBar: Text(
        'اختر اشتراكك 💎',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : AppColors.textBlack,
          fontFamily: 'SomarSans',
        ),
      ),
      body: subscriptionOptionsAsync.when(
        data: (subscriptionOptions) {
          if (selectedSubOption.value == null && subscriptionOptions.isNotEmpty) {
            selectedSubOption.value = subscriptionOptions.first;
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const TitoAdviceWidget(
                        text: AppStrings.dearStudentChooseSubscription,
                      ),
                      20.verticalSpace,
                      ...subscriptionOptions.map((sub) => SubscriptionOptionWidget(
                        totalPrice: sub.price,
                        discountedPrice: sub.discounts.isNotEmpty ? sub.realPrice : null,
                        percentageDiscount: sub.discounts.isNotEmpty ? sub.percentage : null,
                        descriptionText: sub.description,
                        gradientColors: sub.gradientColors.isEmpty 
                          ? [const Color(0XFF175DC7), const Color(0XFF00C4F6)] 
                          : sub.gradientColors,
                        innerColor: sub.innterColor ?? const Color(0XFF175DC7),
                        onPressed: () => selectedSubOption.value = sub,
                        isSelected: selectedSubOption.value == sub,
                      )),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                child: BigButton(
                  text: AppStrings.continueText,
                  onPressed: selectedSubOption.value != null
                      ? () {
                          context.pushNamed(AppRoutes.subscriptions.name,
                              extra: {'subscription': selectedSubOption.value});
                        }
                      : null,
                ),
              ),
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
