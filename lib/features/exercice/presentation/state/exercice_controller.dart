import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/home/data/courses_repository.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/router/app_router.dart';

import '../../../../services/course_service.dart';
import '../../../../services/actions/bottom_sheet_service.dart';
import 'package:tayssir/features/streaks/presentation/streak_notifier.dart';
import 'exercise_state.dart';

final currentUnitIdProvider = StateProvider<int>((ref) => 0);
final currentChapterIdProvider = StateProvider<int>((ref) => 0);

enum ResultStatus { unset, bad, good, average }

final exercicesProvider =
    StateNotifierProvider.autoDispose<ExerciseNotifier, ExerciseState>((ref) {
  final courseService = ref.watch(dataServiceProvider);
  final chapterId = ref.watch(currentChapterIdProvider);
  return ExerciseNotifier(
    chapterId,
    courseService,
    ref,
  );
});

class ExerciseNotifier extends StateNotifier<ExerciseState> {
  final int chapterId;
  final DataService courseService;
  // Timer? _timer;
  final Ref ref;
  DateTime? _startTime;
  ExerciseNotifier(this.chapterId, this.courseService, this.ref)
      : super(ExerciseState.initial()) {
    getExercices();
    // _startTimer();
    _startTime = DateTime.now();
  }
  void getExercices() async {
    final exercises = courseService.getExercises(chapterId);
    state = state.copyWith(exercises: exercises);
  }

  Duration _calculateElapsedTime() {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  void nextPage() async {
    if (state.currentPage == state.exercises.length - 1) return;
    // incrementCurrentExercise();
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    state = state.copyWith(
        currentPage: state.currentPage + 1,
        currentExercice: state.currentExerciceIndex + 1);
    await Future.delayed(const Duration(milliseconds: 1000));
    state = state.clearIsCorrect();
  }

  // void _startTimer() {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     state = state.copyWith(
  //         elapsedTime: state.elapsedTime + const Duration(seconds: 1));
  //   });
  // }

  // void _stopTimer() {
  //   _timer?.cancel();
  // }

  void goToFirstPage() {
    state.pageController.jumpToPage(0);
    state = state.copyWith(currentPage: 0);
  }

  void showVideo() {
    state = state.showVideo();
  }

  void hideVideo() {
    state = state.hideVideo();
  }

  void hideResults() {
    state = state.copyWith(isShowResult: false);
  }

  void validateExercise() {
    if (state.currentExerciceIndex < state.exercises.length - 1) {
      state = state.copyWith(
        numberofCorrectAnswers: state.isCorrect
            ? state.numberofCorrectAnswers + 1
            : state.numberofCorrectAnswers,
      );
    }
  }

  void handleMidResults() {
    if (state.accuracy == 1) {
      state = state.copyWith(resultStatus: ResultStatus.good);
    } else if (state.accuracy >= 0.5) {
      state = state.copyWith(resultStatus: ResultStatus.average);
    } else if (state.accuracy < 0.5) {
      state = state.copyWith(resultStatus: ResultStatus.bad);
    }
  }

  void incrementCurrentExercise() {
    state = state.copyWith(currentExercice: state.currentExerciceIndex + 1);
  }

  Future<void> nextExerise(BuildContext context) async {
    hideResults();
    if (state.currentExerciceIndex < state.exercises.length - 1) {
      final exercicePoints = state.currentExercise.points;
      final isCorrect = state.isCorrect;
      state = state.copyWith(
        points: state.points + (isCorrect ? exercicePoints : 0),
        numberofCorrectAnswers: state.isCorrect
            ? state.numberofCorrectAnswers + 1
            : state.numberofCorrectAnswers,
      );
      state = state.addSubmissionAnswer(SubmissionAnswer(
          questionId: state.currentExercise.id, isCorrect: isCorrect));
      if (state.currentExerciceIndex == state.midResultIndex) {
        handleMidResults();
        context.pushNamed(AppRoutes.midResults.name);
        return;
      }
      nextPage();
    } else {
      await completeExercise(context);
    }
  }

  Future<void> completeExercise(BuildContext context) async {
    final time = _calculateElapsedTime();
    final exercicePoints = state.currentExercise.points;
    final isCorrect = state.isCorrect;
    final wonPoints = isCorrect ? exercicePoints : 0;
    state = state.addSubmissionAnswer(SubmissionAnswer(
        questionId: state.currentExercise.id, isCorrect: isCorrect));
    state = state.copyWith(
      points: state.points + wonPoints,
      numberofCorrectAnswers: state.isCorrect
          ? state.numberofCorrectAnswers + 1
          : state.numberofCorrectAnswers,
      elapsedTime: time,
    );

    state = state.clearIsCorrect();
    // _stopTimer();

    // add try catch here to handle errors later on
    state = state.setSubmittingStatus(const AsyncLoading<void>());
    final response = await ref.read(dataProvider.notifier).submitAnswers(
          state.submissionAnswers,
          chapterId,
          // time,
        );
    final submittedPoints = response.totalPoints;
    state = state.setResultPoints(submittedPoints);
    state = state.setBestProgress(response.bestProgress);
    
    // Only update points if we have a real user logged in
    final user = ref.read(userNotifierProvider).valueOrNull;
    if (user != null) {
      ref.read(userNotifierProvider.notifier).updateUserPoints(submittedPoints);
    }

    // Ping streak async, listeners like ResultScreen will catch it if successful
    ref.read(streakNotifierProvider.notifier).pingStreak();

    state = state.setSubmittingStatus(const AsyncData<void>(null));
    if (context.mounted) {
      context.pushReplacementNamed(AppRoutes.results.name);
    }
  }

  // reset exercices
  void resetExercices() {
    state = state.copyWith(
      currentPage: 0,
      currentExercice: 0,
      numberofCorrectAnswers: 0,
    );
    goToFirstPage();
    // _startTimer();
  }

  //Side Note:  I can get rid of context here and just use the ref.listen to listen  ,
  //and have  a state varaible to check if it get correct or no and based on that show the dialogs ,
  // for now i will keep it like this , if the application get bigger i will change it to the other way
  void checkAnswer(BuildContext context, bool isCorrect
      //  {
      /// @deperacted
      // VoidCallback? onSuccess,
      // VoidCallback? onError,
      // }
      ) async {
    final currentExercise = state.currentExercise;

    // final isCorrect = currentExercise.checkAnswer(answer);
    state = state.copyWith(isShowResult: true, isCorrect: isCorrect);
    if (state.isCorrect) {
      BottomSheetService.showSuccessBottomSheet(context, state.isCorrect, () {
        nextExerise(context);
        // if (onSuccess != null) {
        //   onSuccess();
        // }

        context.pop();
        // handleRemarks(context);
      });
    } else {
      BottomSheetService.showErrorBottomSheet(
          context, currentExercise.getFeedback(), () {
        nextExerise(context);
        // if (onError != null) {
        //   onError();
        // }
        context.pop();
        // handleRemarks(context);
      }, currentExercise.explanation.isLatex);
    }
  }

  Future<void> reportCurrentExercise({String? reason}) async {
    state = state.setReportingStatus(const AsyncLoading<void>());
    try {
      await ref.read(dataRepoProvider).reportExercise(
            state.currentExercise.id,
            reason,
          );
      state = state.setReportingStatus(const AsyncData<void>(null));
      AppLogger.logInfo('Exercise reported successfully');
    } catch (e, st) {
      state = state.setReportingStatus(AsyncValue.error(e, st));
      AppLogger.logError('Failed to report exercise: $e');
    }
  }

  // void handleRemarks(BuildContext context) async {
  //   // await Future.delayed(const Duration(milliseconds: 1000));
  //   if (state.currentExercise.remark != null) {
  //     AppLogger.logInfo('showing remark dialog');
  //     if (context.mounted) {
  //       DialogService.showRemarkDialog(context, state.currentExercise.remark!,
  //           ref.watch(exercicesProvider).currentExercise.hintImage);
  //     }
  //   }
  // }

  @override
  void dispose() {
    // _stopTimer();
    state.pageController.dispose();

    super.dispose();
  }
}
