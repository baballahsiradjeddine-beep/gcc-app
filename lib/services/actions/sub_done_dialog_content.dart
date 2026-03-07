import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';

class SubDoneDialogContent extends StatelessWidget {
  const SubDoneDialogContent({
    super.key,
    required this.onContinue,
    this.isDone = true,
    this.status = SubscrptionStatus.success,
  });
  final Function() onContinue;
  final bool isDone;
  final SubscrptionStatus status;
  @override
  Widget build(BuildContext context) {
    String getSvg() {
      switch (status) {
        case SubscrptionStatus.pending:
          return SVGs.titoSusbscriptionPending;
        case SubscrptionStatus.failure:
          return SVGs.titoSubFailure;
        case SubscrptionStatus.success:
          return SVGs.titoSubscriptionGood;
      }
    }

    String getAssetKey() {
      switch (status) {
        case SubscrptionStatus.pending:
          return 'tito_sub_pending';
        case SubscrptionStatus.failure:
          return 'tito_sub_failure';
        case SubscrptionStatus.success:
          return 'tito_sub_good';
      }
    }

    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0.85.sw,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.85),
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(
                  color: (status == SubscrptionStatus.failure ? Colors.redAccent : const Color(0xFF0077B6)).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    status == SubscrptionStatus.success
                        ? "أهلاً بك في التميز! 💎"
                        : (status == SubscrptionStatus.pending ? "طلبك قيد المعالجة ⏳" : "عذراً، حدث خطأ ❌"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                  
                  24.verticalSpace,
                  
                  DynamicAppAsset(
                    assetKey: getAssetKey(),
                    fallbackAssetPath: getSvg(),
                    type: AppAssetType.svg,
                    height: 200.h,
                  ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms).shimmer(delay: 1.5.seconds, duration: 1.5.seconds),
                  
                  16.verticalSpace,
                  
                  Text(
                    status == SubscrptionStatus.success
                        ? "تم تفعيل اشتراكك بنجاح. استمتع بكل المزايا الحصرية!"
                        : (status == SubscrptionStatus.pending ? "نحن نعمل على تفعيل اشتراكك الآن، ستتلقى إشعاراً قريباً." : "لم نتمكن من إتمام العملية، يرجى المحاولة مرة أخرى."),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 15.sp,
                      fontFamily: 'SomarSans',
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  
                  32.verticalSpace,
                  
                  BigButton(
                      text: status == SubscrptionStatus.failure
                          ? AppStrings.ok
                          : AppStrings.mainMenu,
                      onPressed: () {
                        onContinue();
                        context.pop();
                      }),
                ],
              ),
            ),
          ],
        ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
    );
  }
}
