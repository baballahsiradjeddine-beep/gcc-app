import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/features/exercice/presentation/widgets/video/pause_indicator.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import '../../state/video_provider.dart';
import 'package:video_player/video_player.dart';

import 'controls_panel.dart';
import 'video_duration_slider.dart';

class VideoViewPortraitWidget extends ConsumerWidget {
  const VideoViewPortraitWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: size.height * .3,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    ref.read(videoProvider.notifier).togglePlayPause();
                  },
                  child: videoState.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoState.player!.value.aspectRatio,
                          child: VideoPlayer(
                            videoState.player!,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        )),
              if (!videoState.isPlaying) const PauseIndicator(),
            ],
          ),
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: VideoDurationSlider()),
              ],
            ),
            ControlsPanel(),
          ],
        ),
        10.verticalSpace,
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: BigButton(
              text: 'السؤال التالي',
              onPressed: () {
                ref.read(exercicesProvider.notifier).hideVideo();
                ref.read(exercicesProvider.notifier).nextExerise(context);
              }),
        ),
      ],
    );
  }
}
