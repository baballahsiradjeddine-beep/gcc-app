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
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(status == SubscrptionStatus.failure
                      ? Images.failureBg
                      : Images.successBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  DynamicAppAsset(
                    assetKey: getAssetKey(),
                    fallbackAssetPath: getSvg(),
                    type: AppAssetType.svg,
                    height: 200.h,
                  ),
                  10.verticalSpace,
                  BigButton(
                      text: status == SubscrptionStatus.failure
                          ? AppStrings.ok
                          : AppStrings.mainMenu,
                      onPressed: () {
                        onContinue();
                        // Navigator.of(context).pop();
                        context.pop();
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
