import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:video_player/video_player.dart';

class VideoState extends Equatable {
  final VideoPlayerController? videoPlayerController;
  final bool isFullScreen;
  final Duration? storedVideoPosition;
  final String? videoUrl;
  const VideoState({
    this.videoPlayerController,
    this.isFullScreen = false,
    this.storedVideoPosition,
    this.videoUrl,
  });

  VideoState copyWith({
    VideoPlayerController? videoPlayerController,
    bool? isFullScreen,
    Duration? storedVideoPosition,
    String? videoUrl,
  }) {
    return VideoState(
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      storedVideoPosition: storedVideoPosition ?? this.storedVideoPosition,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  VideoState setVideoUrl(String videoUrl) {
    return VideoState(
      videoPlayerController: videoPlayerController,
      isFullScreen: isFullScreen,
      storedVideoPosition: storedVideoPosition,
      videoUrl: videoUrl,
    );
  }

  VideoPlayerController? get player => videoPlayerController;

  bool get isMuted => player?.value.volume == 0 ?? false;

  bool get isPlaying => player?.value.isPlaying ?? false;

  bool get isInitialized => player?.value.isInitialized ?? false;

  @override
  List<Object?> get props =>
      [videoPlayerController, isFullScreen, storedVideoPosition, videoUrl];

  @override
  String toString() {
    return 'VideoState(videoPlayerController: $videoPlayerController, isFullScreen: $isFullScreen, storedVideoPosition: $storedVideoPosition, videoUrl: $videoUrl)';
  }
}

class VideoNotifier extends StateNotifier<VideoState> {
  VideoNotifier(videoUrl) : super(const VideoState()) {
    setVideoUrl(videoUrl);
  }
  void initVideo() {
    _initializeVideo();
  }

  void _initializeVideo() async {
    if (state.videoUrl == null) return;

    final uri = Uri.parse(state.videoUrl!);
    final controller = VideoPlayerController.networkUrl(uri);
    state = state.copyWith(videoPlayerController: controller);
    await controller.initialize();
    state = state.copyWith(videoPlayerController: controller);

    controller.addListener(
      () {
        state = state.copyWith(videoPlayerController: controller);
      },
    );
    // AppLogger.logInfo(state.videoUrl);
    // state.videoPlayerController!.addListener(_videoListener);
  }

  // void _videoListener() {
  //   if (state.videoPlayerController!.value.isCompleted) {
  //     print('Video Completed');
  //   }
  // }
  void setVideoUrl(String? videoUrl) {
    if (videoUrl == null) return;
    if (state.videoUrl == videoUrl) return;
    if (state.videoPlayerController != null) {
      state.videoPlayerController!.dispose();
    }
    state = state.setVideoUrl(videoUrl);
    initVideo();
  }

  void toggleFullScreen() {
    if (!state.isInitialized) return;
    state = state.copyWith(isFullScreen: !state.isFullScreen);
  }

  void togglePlayPause() {
    if (!state.isInitialized) return;
    if (state.isPlaying) {
      state.player!.pause();
    } else {
      state.player!.play();
    }
    state = state;
  }

  void toggleVolume() {
    if (!state.isInitialized) return;
    state.player!.setVolume(state.isMuted ? 1 : 0);
  }

  // void storePosition() {
  //   if (state.isInitialized) {
  //     state = state.copyWith(storedVideoPosition: state.player!.value.position);
  //   }
  // }

  void pauseVideo() {
    if (state.isPlaying) {
      state.player!.pause();
    }
  }

  void forward() {
    if (!state.isInitialized) return;
    final position = state.player!.value.position;
    state.player!.seekTo(position + const Duration(seconds: 10));
  }

  @override
  void dispose() {
    // state.player?.removeListener(_videoListener);
    state.player?.dispose();
    super.dispose();
  }
}

final videoProvider =
    StateNotifierProvider.autoDispose<VideoNotifier, VideoState>((ref) {
  final currentVideo =
      ref.watch(exercicesProvider).currentExercise.explanationVideo;
  return VideoNotifier(
    currentVideo,
  );
});
