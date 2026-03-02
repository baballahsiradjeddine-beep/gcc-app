import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_bubble_talk_widget.dart';
import 'package:tayssir/features/subscriptions/presentation/card/subscribe_card_button.dart';
import 'package:tayssir/features/subscriptions/presentation/state/subscription_controller.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/enums/triangle_side.dart';
import 'package:tayssir/utils/extensions/async_value.dart';

import '../../../../common/app_buttons/big_button.dart';
import '../../../../common/core/app_scaffold.dart';
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
    final state = ref.watch(subscriptionControllerProvider);
    final shouldShowError = state.state is AsyncError;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    cardNumberController.addListener(() {
      if (cardNumberController.text.length == 12) {
        isValid.value = true;
      } else {
        isValid.value = false;
      }
    });

    ref.listen(subscriptionControllerProvider.select((v) => v.state), (prv, nxt) {
      nxt.handleSideThings(context, () {
        DialogService.showSubscriptionDoneDialog(context, () {
          context.goNamed(AppRoutes.home.name);
        });
      }, shouldShowError: false);
    });

    return AppScaffold(
      paddingY: 0,
      topSafeArea: true,
      body: Column(
        children: [
          // Header Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                    children: [
                      TextSpan(
                        text: "Tay",
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
                      ),
                      const TextSpan(
                        text: "ssir",
                        style: TextStyle(color: Color(0xFF00B4D8)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? Colors.white : const Color(0xFF64748B),
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          Expanded(
            child: SliverScrollingWidget(
              children: [
                20.verticalSpace,
                
                // Dolphin & Speech Bubble
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🐬",
                      style: TextStyle(fontSize: 70.sp),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .moveY(begin: 0, end: -6, duration: 4.seconds, curve: Curves.easeInOutSine),
                    
                    8.horizontalSpace,
                    
                    SizedBox(
                      width: 180.w,
                      child: const TitoBubbleTalkWidget(
                        text: "أحسنت الإختيار! تيسير رفيقك نحو التفوق 😉",
                        triangleSide: TriangleSide.right,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),
                
                40.verticalSpace,
                
                // Virtual Card with Subscription Card Input
                SubscribeCardButton(
                  controller: cardNumberController,
                  hasError: shouldShowError,
                  price: subscription.realPrice,
                ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack),
                
                20.verticalSpace,
                
                // Error message (if any)
                if (shouldShowError)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        (state.state.asError!.error as AppException).message.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ),
                  ).animate().fadeIn().shake(),
                
                40.verticalSpace,
              ],
            ),
          ),
          
          // Fixed Bottom Action
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, 32.r),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A).withOpacity(0.9) : Colors.white.withOpacity(0.9),
                  border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))),
                ),
                child: BigButton(
                  text: AppStrings.check,
                  onPressed: isValid.value && !state.state.isLoading
                      ? () => ref.read(subscriptionControllerProvider.notifier).subscribeWithCard(cardNumberController.text, subscription)
                      : null,
                ).animate().fadeIn(delay: 700.ms).scale(curve: Curves.easeOutBack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
