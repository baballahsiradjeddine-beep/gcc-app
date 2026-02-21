import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../state/video_provider.dart';

class PauseIndicator extends ConsumerWidget {
  const PauseIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final videoState = ref.watch(videoProvider);
    return GestureDetector(
      onTap: () {
        ref.read(videoProvider.notifier).togglePlayPause();
      },
      child: const Icon(Icons.play_arrow, color: Colors.white, size: 100),
    );
  }
}
