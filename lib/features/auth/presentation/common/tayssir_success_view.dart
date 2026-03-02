import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/auth/presentation/common/header_text.dart';

class TayssirSuccessView extends HookConsumerWidget {
  const TayssirSuccessView({
    super.key,
    required this.title,
    required this.titoText,
    required this.onPressed,
    this.isLoading = false,
    this.subPress,
    this.onSubPressed,
    this.buttonText,
  });

  final String title;
  final String titoText;
  final String? buttonText;
  final bool isLoading;
  final VoidCallback onPressed;
  final VoidCallback? subPress;
  final VoidCallback? onSubPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingB: 0,
      body: SliverScrollingWidget(
        children: [
          24.verticalSpace,
          HeaderText(text: title)
              .animate().fadeIn().slideY(begin: -0.1, end: 0),
          
          32.verticalSpace,
          
          TitoAdviceWidget(
            text: titoText,
            isHorizontal: false,
          ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),
          
          60.verticalSpace,
          
          BigButton(
            text: buttonText ?? AppStrings.check,
            onPressed: isLoading ? null : onPressed,
          ).animate().fadeIn(delay: 300.ms).scale(),
          
          if (onSubPressed != null) ...[
            12.verticalSpace,
            BigButton(
              buttonType: ButtonType.secondary,
              text: AppStrings.iHaveCode,
              onPressed: onSubPressed,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          ],
          
          if (subPress != null) ...[
            12.verticalSpace,
            BigButton(
              buttonType: ButtonType.outline,
              text: AppStrings.changeEmail,
              onPressed: subPress,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
          ],
          
          40.verticalSpace,
        ],
      ),
    );
  }
}
