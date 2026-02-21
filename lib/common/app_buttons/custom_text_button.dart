import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.customColor});

  final String text;
  final VoidCallback? onPressed;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    final color = customColor ?? AppColors.primaryColor;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: onPressed == null ? color.withValues(alpha: 0.3) : color,
          fontSize: 14.spMin,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
