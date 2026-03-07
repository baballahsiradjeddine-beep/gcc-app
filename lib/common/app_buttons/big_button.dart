import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

enum ButtonType { primary, secondary, outline }

class BigButton extends HookConsumerWidget {
  const BigButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonType = ButtonType.primary,
    this.width,
    this.height,
    this.hasBorder = true,
  });

  final Function()? onPressed;
  final String text;
  final ButtonType buttonType;
  final double? width;
  final double? height;
  final bool hasBorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isActive = onPressed != null;

    Decoration decoration;
    TextStyle textStyle;

    switch (buttonType) {
      case ButtonType.primary:
        decoration = BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20.r), // 1.25rem
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
          ],
        );
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'SomarSans',
        );
        break;
      case ButtonType.secondary:
        decoration = BoxDecoration(
          color: isDark 
              ? AppColors.primaryColor.withOpacity(0.1) 
              : AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        );
        textStyle = TextStyle(
          color: isDark ? AppColors.primaryColor : AppColors.primaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'SomarSans',
        );
        break;
      case ButtonType.outline:
        decoration = BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 2,
          ),
        );
        textStyle = TextStyle(
          color: isDark ? const Color(0xFFCBD5E1) : AppColors.textBlack,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'SomarSans',
        );
        break;
    }

    return AnimatedScale(
      scale: isActive ? 1.0 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 56.h,
          decoration: decoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isActive
                  ? () {
                      ref.read(specialEffectServiceProvider).playEffects();
                      onPressed!();
                    }
                  : null,
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  // Premium Shine Effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.3, 0.5, 0.7],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      text,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
