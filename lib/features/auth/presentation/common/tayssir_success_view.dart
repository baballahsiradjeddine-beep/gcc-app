import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/header_text.dart';
import 'package:tayssir/utils/extensions/context.dart';

class TayssirSuccessView extends HookConsumerWidget {
  const TayssirSuccessView(
      {super.key,
      required this.title,
      required this.titoText,
      required this.onPressed,
      this.isLoading = false,
      this.subPress,
      this.onSubPressed,
      this.buttonText});
  final String title;
  final String titoText;
  final String? buttonText;
  final bool isLoading;
  final VoidCallback onPressed;
  final VoidCallback? subPress;
  final VoidCallback? onSubPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
        paddingB: 0,
        body: SliverScrollingWidget(
          children: [
            HeaderText(
              text: title,
            ),
            20.verticalSpace,
            TitoAdviceWidget(
                text: titoText,
                isHorizontal: false,
                size: context.isSmallDevice ? 200.h : 300.h),
            const Spacer(),
            BigButton(
                text: buttonText ?? AppStrings.check,
                onPressed: isLoading
                    ? null
                    : () {
                        onPressed();
                      }),
            if (onSubPressed != null) ...[
              10.verticalSpace,
              BigButton(
                  text: AppStrings.iHaveCode,
                  onPressed: () {
                    onSubPressed!();
                  }),
            ],
            if (subPress != null) ...[
              10.verticalSpace,
              BigButton(
                  text: AppStrings.changeEmail,
                  onPressed: () {
                    subPress!();
                  }),
            ],
            10.verticalSpace,
          ],
        ));
  }
}
