import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';

import 'exercice_controller.dart';

class SubmissionAnswer {
  final int questionId;
  final bool isCorrect;

  const SubmissionAnswer({
    required this.questionId,
    required this.isCorrect,
  });

  // to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question_id': questionId,
      'answered_correctly': isCorrect,
    };
  }
}

class ExerciseState extends Equatable {
  final List<ExerciseModel> exercises;
  final int currentExerciceIndex;
  final int currentPage;
  final int numberofCorrectAnswers;
  final PageController pageController;
  final bool isShowResult;
  final bool isShowVideo;
  final bool isCorrect;
  final Duration elapsedTime;
  final ResultStatus resultStatus;
  final int points;
  final List<SubmissionAnswer> submissionAnswers;
  final int resultPoints;
  final double bestProgress;
  final AsyncValue<void> submittingStatus;
  final AsyncValue<void> reportingStatus;
  const ExerciseState(
      {required this.exercises,
      required this.currentExerciceIndex,
      required this.pageController,
      required this.currentPage,
      this.numberofCorrectAnswers = 0,
      this.isShowResult = false,
      this.isShowVideo = false,
      this.isCorrect = false,
      this.submissionAnswers = const [],
      this.points = 0,
      this.resultPoints = 0,
      this.bestProgress = 0.0,
      this.elapsedTime = Duration.zero,
      this.resultStatus = ResultStatus.unset,
      this.submittingStatus = const AsyncValue.data(null),
      this.reportingStatus = const AsyncValue.data(null)});

  // factory initial
  factory ExerciseState.initial() {
    return ExerciseState(
      exercises: const [],
      currentExerciceIndex: 0,
      pageController: PageController(initialPage: 0),
      currentPage: 0,
      points: 0,
      numberofCorrectAnswers: 0,
      resultPoints: 0,
      bestProgress: 0.0,
    );
  }

  ExerciseModel get currentExercise => exercises[currentExerciceIndex];
  double get progress =>
      exercises.isEmpty ? 0 : (currentPage + 1) / exercises.length.toDouble();
  double get accuracy =>
      numberofCorrectAnswers /
      exercises.sublist(0, currentExerciceIndex + 1).length.toDouble();

  int get midResultIndex {
    if (exercises.length < 3) {
      return exercises.length - 1;
    }
    return (exercises.length / 2).floor();
  }

  ExerciseState copyWith({
    List<ExerciseModel>? exercises,
    int? currentExercice,
    PageController? pageController,
    int? currentPage,
    int? numberofCorrectAnswers,
    bool? isShowResult,
    bool? isShowVideo,
    bool? isCorrect,
    Duration? elapsedTime, // Add this line
    ResultStatus? resultStatus,
    int? points,
    List<SubmissionAnswer>? submissionAnswers,
    int? resultPoints,
    double? bestProgress,
    AsyncValue<void>? submittingStatus,
    AsyncValue<void>? reportingStatus,
  }) {
    return ExerciseState(
      exercises: exercises ?? this.exercises,
      currentExerciceIndex: currentExercice ?? currentExerciceIndex,
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      numberofCorrectAnswers:
          numberofCorrectAnswers ?? this.numberofCorrectAnswers,
      isShowResult: isShowResult ?? this.isShowResult,
      isShowVideo: isShowVideo ?? this.isShowVideo,
      isCorrect: isCorrect ?? this.isCorrect,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      resultStatus: resultStatus ?? this.resultStatus,
      points: points ?? this.points,
      submissionAnswers: submissionAnswers ?? this.submissionAnswers,
      resultPoints: resultPoints ?? this.resultPoints,
      bestProgress: bestProgress ?? this.bestProgress,
      submittingStatus: submittingStatus ?? this.submittingStatus,
      reportingStatus: reportingStatus ?? this.reportingStatus,
    );
  }

  ExerciseState showVideo() {
    return copyWith(isShowVideo: true);
  }

  ExerciseState hideVideo() {
    return copyWith(isShowVideo: false);
  }

  ExerciseState showResult() {
    return copyWith(isShowResult: true);
  }

  ExerciseState clearIsCorrect() {
    return copyWith(isCorrect: false);
  }

  ExerciseState setPoints(int points) {
    return copyWith(points: points);
  }

  ExerciseState changeResultStatus(ResultStatus status) {
    return copyWith(resultStatus: status);
  }

  ExerciseState setElapsedTime(Duration time) {
    return copyWith(elapsedTime: time);
  }

  ExerciseState addSubmissionAnswer(SubmissionAnswer answer) {
    return copyWith(
      submissionAnswers: [...submissionAnswers, answer],
    );
  }

  ExerciseState setResultPoints(int points) {
    return copyWith(resultPoints: points);
  }

  ExerciseState setBestProgress(double progress) {
    return copyWith(bestProgress: progress);
  }

  ExerciseState setSubmittingStatus(AsyncValue<void> status) {
    return copyWith(submittingStatus: status);
  }

  ExerciseState setReportingStatus(AsyncValue<void> status) {
    return copyWith(reportingStatus: status);
  }

  @override
  List<Object?> get props => [
        exercises,
        currentExerciceIndex,
        currentPage,
        numberofCorrectAnswers,
        pageController,
        isShowResult,
        isShowVideo,
        isCorrect,
        resultStatus,
        elapsedTime,
        points,
        submissionAnswers,
        resultPoints,
        bestProgress,
        submittingStatus,
        reportingStatus,
      ];
}
