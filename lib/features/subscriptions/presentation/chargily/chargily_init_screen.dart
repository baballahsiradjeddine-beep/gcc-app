// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/subscriptions/presentation/chargily/chargily_controller.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/custom_back_button.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

class ChargilyInitScreen extends HookConsumerWidget {
  const ChargilyInitScreen({super.key, required this.subscription});
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotorCodeController = useTextEditingController();
    final result = useState<bool?>(null);
    final controller = ref.watch(chargilyControllerProvider);

    ref.listen(chargilyControllerProvider.select((v) => v.status), (prv, nxt) {
      nxt.handleSideThings(context, () {}, shouldShowError: true);
    });

    ref.listen(chargilyControllerProvider.select((v) => v.url),
        (prv, nxt) async {
      if (nxt != null) {
        final res = await context.pushNamed(AppRoutes.chargilyWebView.name,
            extra: {'checkoutUrl': nxt});
        result.value = res as bool?;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (result.value == true) {
            ref.read(userNotifierProvider.notifier).updateUserSub(subscription);
            await ref.read(dataProvider.notifier).refreshData();
            DialogService.showSubscriptionDoneDialog(context, () async {
              context.goNamed(AppRoutes.home.name);
            });
          } else {
            DialogService.showSubscriptionDialog(context, () {
              // context.pop();
            }, SubscrptionStatus.failure);
          }
        });
      }
    });

    // useEffect(() {
    //   if (result.value != null) {
    //     if (result.value!) {
    //       DialogService.showSubscriptionDoneDialog(context, () {
    //         context.goNamed(AppRoutes.home.name);
    //       });
    //     } else {
    //       DialogService.showSubscriptionPendingDialog(context, () {
    //         context.pop();
    //       });
    //     }
    //   }
    //   return null;
    // }, [result.value]);

    return AppScaffold(
      paddingY: 0,
      topSafeArea: false,
      body: SliverScrollingWidget(
        children: [
          50.verticalSpace,
          const CustomBackButton(),
          // const TitoAdviceWidget(text: AppStrings.goodChoice),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدفع عبر بريدي موب',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'سيتم توجيهك إلى منصة الدفع الآمنة لإتمام عملية الدفع باستخدام بريدي موب أو المحفظة الإلكترونية.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                )
              ],
            ),
          ),
          20.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 20.w,
                      color: Colors.blue[600],
                    ),
                    8.horizontalSpace,
                    Text(
                      'كود المروج (اختياري)',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                TextFormField(
                  controller: promotorCodeController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'أدخل كود المروج',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          BorderSide(color: Colors.blue[600]!, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    prefixIcon: Icon(
                      Icons.discount,
                      color: Colors.grey[400],
                      size: 20.w,
                    ),
                  ),
                ),
                8.verticalSpace,
                Text(
                  'أدخل كود المروج ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          BigButton(
            text: AppStrings.confirm,
            onPressed: controller.status.isLoading
                ? null
                : () {
                    ref
                        .read(chargilyControllerProvider.notifier)
                        .initChargilyPayment(
                          subscription.id,
                          promotorCodeController.text.isEmpty
                              ? null
                              : promotorCodeController.text,
                        );
                  },
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
