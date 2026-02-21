import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:video_player/video_player.dart';

import '../../state/video_provider.dart';

class ControlsPanel extends ConsumerWidget {
  const ControlsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: AppColors.videoControls),
        child: Row(
          children: [
            // a play pause Button
            GestureDetector(
              onTap: () {
                ref.read(videoProvider.notifier).togglePlayPause();
              },
              child: Icon(
                videoState.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 16,
                color: Colors.white,
              ),
            ),
            15.horizontalSpace,
            GestureDetector(
              onTap: () {
                ref.read(videoProvider.notifier).forward();
              },
              child: const Icon(
                Icons.forward_10,
                size: 16.0,
                color: Colors.white,
              ),
            ),

            const Spacer(),
            Row(
              children: [
                !videoState.isInitialized
                    ? const Text(
                        '0:00/0:00',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      )
                    : ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: videoState.player!,
                        builder: (context, value, child) {
                          final position = value.position;
                          final minutes = position.inMinutes;
                          final seconds = position.inSeconds.remainder(60);
                          return Text(
                            '$minutes:${seconds.toString().padLeft(2, '0')} / ${value.duration.inMinutes}:${value.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),

                15.horizontalSpace,

                GestureDetector(
                  onTap: () {
                    ref.read(videoProvider.notifier).toggleVolume();
                  },
                  child: Icon(
                    videoState.isMuted ? Icons.volume_off : Icons.volume_up,
                    size: 16.0,
                    color: Colors.white,
                  ),
                ),
                15.horizontalSpace,
                // full screen button
                GestureDetector(
                  onTap: () {
                    ref.read(videoProvider.notifier).toggleFullScreen();
                  },
                  child: const Icon(
                    Icons.fullscreen,
                    size: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomSoundWidget extends StatelessWidget {
  const CustomSoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
