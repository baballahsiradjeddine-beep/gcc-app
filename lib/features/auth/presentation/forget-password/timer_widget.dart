import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerWidget extends HookConsumerWidget {
  const TimerWidget({super.key, required this.currentTimeSeconds});

  final int currentTimeSeconds;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    formatTime() {
      final minutes = currentTimeSeconds ~/ 60;
      final seconds = currentTimeSeconds % 60;
      if (seconds < 10) {
        return '$minutes:0$seconds';
      }
      return '$minutes:$seconds';
    }

    return Text(
      formatTime(),
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12.sp,
      ),
    );
  }
}
