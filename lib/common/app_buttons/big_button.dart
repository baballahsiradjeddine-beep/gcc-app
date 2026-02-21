import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/push_buttons/pushable_button.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

enum ButtonType { primary, secondary }

extension ButtonX on ButtonType {
  List<Color> get colors {
    switch (this) {
      case ButtonType.primary:
        return const [
          Color(0xff00C9FF),
          Color(0xff00A7FA),
        ];
      case ButtonType.secondary:
        return const [Color(0xffECF6FF)];
    }
  }

  Color get textColor {
    switch (this) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return const Color(0xff00A7FA);
    }
  }
}

class BigButton extends HookConsumerWidget {
  const BigButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.hasBorder = true,
      this.buttonType = ButtonType.primary});

  final Function()? onPressed;
  final String text;
  final ButtonType buttonType;
  final bool hasBorder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = onPressed != null;

    return PushableButton(
        height: 40.h,
        elevation: 4,
        hslColor: HSLColor.fromColor(buttonType.colors.first),
        gradiantColors: buttonType.colors,
        hslDisabledColor: HSLColor.fromColor(const Color(0xffEEEEEE)),
        onPressed: onPressed == null
            ? null
            : () {
                ref.read(specialEffectServiceProvider).playEffects();
                onPressed!();
              },
        hasBorder: onPressed == null,
        borderRadius: 30,
        shadows: const [
          // BoxShadow(
          //   color: Colors.black.withValues(alpha:0.3),
          //   // blurRadius: 10,
          //   offset: const Offset(
          //     0,
          //     4,
          //   ),
          // ),
          // BoxShadow(
          //   color: buttonType.colors.first,
          //   blurRadius: 10,
          //   spreadRadius: 1,
          //   offset: const Offset(
          //     0,
          //     4,
          //   ),
          // )
        ],
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:
                  isActive ? buttonType.textColor : AppColors.disabledTextColor,
              fontSize: 18,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              fontFamily: 'SomarSans',
            ),
          ),
        ));
  }
}
