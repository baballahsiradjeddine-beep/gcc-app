import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/data/submission_progress_response.dart';

import '../features/exercice/presentation/state/exercise_state.dart';
import '../providers/data/models/chapter_model.dart';
import '../providers/data/models/exercise_model.dart';
import '../providers/data/models/material_model.dart';
import '../providers/data/models/unit_model.dart';
import '../features/home/data/courses_repository.dart';

final dataServiceProvider = Provider<DataService>((ref) {
  final dataRepository = ref.watch(dataRepoProvider);
  // final connectivityService = ref.watch(connectivityProvider);
  return DataService(
    dataRepository,
    //  connectivityService
  );
});

class DataService {
  final DataRepository _coursesRepository;
  DataService(
    this._coursesRepository,
    // this._connectivityService
  ) {
    // getCourses();
  }
  final List<MaterialModel> modules = [];
  final List<UnitModel> units = [];
  final List<ChapterModel> chapters = [];
  final List<ExerciseModel> exercises = [];

  Future<void> getCourses({int? divisionId}) async {
    await fetchCourses(divisionId: divisionId);
  }

  //fetch courses
  Future<void> fetchCourses({int? divisionId}) async {
    final response = await _coursesRepository.getCourses(divisionId: divisionId);
    clearData();
    modules.addAll(response.modules);
    units.addAll(response.units);
    chapters.addAll(response.chapters);
    exercises.addAll(response.exercises);
  }

  void clearData() {
    modules.clear();
    units.clear();
    chapters.clear();
    exercises.clear();
  }

  MaterialModel getModule(int id) {
    return modules.firstWhere((element) => element.id == id);
  }

  List<UnitModel> getUnits(int moduleId) {
    return units.where((element) => element.materialId == moduleId).toList();
  }

  List<ChapterModel> getChapters(int unitId) {
    return chapters.where((element) => element.unitId == unitId).toList();
  }

  List<ExerciseModel> getExercises(int chapterId) {
    return exercises
        .where((element) => element.chapterId == chapterId)
        .toList();
  }

  Future<SubmissionProgressResponse> submitAnswers(
      List<SubmissionAnswer> answers, int chapterId) async {
    return await _coursesRepository.submitAnswers(chapterId, answers);
  }

  Future<List<ExerciseModel>> getReviewQuestions() async {
    return await _coursesRepository.getTodayReview();
  }

  Future<void> submitReview(List<SubmissionAnswer> results) async {
    await _coursesRepository.submitReview(results);
  }
}
