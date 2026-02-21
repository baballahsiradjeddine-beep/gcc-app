import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class ExeciseNumberWidget extends ConsumerWidget {
  const ExeciseNumberWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 30.h,
      width: 30.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            Color(0xff0080FF),
          ],
        ),
      ),
      child: Text(
        ref.watch(exercicesProvider).currentExerciceIndex + 1 < 10
            ? "0${ref.watch(exercicesProvider).currentExerciceIndex + 1}"
            : "${ref.watch(exercicesProvider).currentExerciceIndex + 1}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
