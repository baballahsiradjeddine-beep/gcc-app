import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/push_buttons/elevated_push.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';

class SmallButton extends ConsumerWidget {
  const SmallButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = Colors.purple,
    this.height,
    this.width,
    this.fontSize,
  });

  final String text;
  final Color color;
  final Function()? onPressed;
  final double? height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableElevatedButton(
      elevation: 5,
      height: height ?? 20.h,
      onPressed: onPressed == null
          ? null
          : () {
              ref.read(specialEffectServiceProvider).playEffects();
              onPressed!();
            },
      disableClick: false,
      borderRadius: 5,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(width ?? 70, height ?? 30),
        maximumSize: Size(width ?? 200, height ?? 30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize ?? 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
