import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../state/video_provider.dart';
import 'package:video_player/video_player.dart';

import 'dummy_slider.dart';

class VideoDurationSlider extends ConsumerWidget {
  const VideoDurationSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: videoState.isInitialized
          ? ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: videoState.player!,
              builder: (context, value, child) {
                return VideoProgressIndicator(
                  videoState.player!,
                  padding: const EdgeInsets.all(0),
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.blue,
                    bufferedColor: Colors.grey.withValues(alpha: .5),
                    backgroundColor: Colors.white,
                  ),
                );
              })
          : const DummySlider(),
    );
  }
}
