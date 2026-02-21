import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../state/exercice_controller.dart';

class ExerciseHeader extends ConsumerWidget {
  const ExerciseHeader({
    super.key,
    required this.progress,
  });

  final double? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Directionality(
        textDirection:
            ref.watch(exercicesProvider).currentExercise.currentDirection,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          minHeight: 15.h,
          borderRadius: BorderRadius.circular(20.r),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
        ),
      ),
    );
  }
}
