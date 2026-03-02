import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/home/data/data_response.dart';
import 'package:tayssir/features/home/data/image_precache_service.dart';
import 'package:tayssir/features/home/data/submit_answer_model.dart';
import 'package:tayssir/providers/data/submission_progress_response.dart';
import 'package:tayssir/utils/extensions/response.dart';

import '../../../providers/data/models/chapter_model.dart';
import '../../../providers/data/models/exercise_model.dart';
import '../../../providers/data/models/material_model.dart';
import '../../../providers/data/models/unit_model.dart';
import '../../exercice/presentation/state/exercise_state.dart';
import 'remote_courses_data_source.dart';

final dataRepoProvider = Provider<DataRepository>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  // final localCoursesDataSource = ref.watch(localCoursesDataSourceProvider);
  return DataRepository(remoteDataSource
      // localCoursesDataSource: localCoursesDataSource
      );
});

class DataRepository {
  final RemoteCoursesDataSource _coursesDataSource;
  // final LocalCoursesDataSource _localCoursesDataSource;

  DataRepository(
    this._coursesDataSource,
    // this._localCoursesDataSource
  );

  Future<DataResponse> getCourses({int? divisionId}) async {
    try {
      // await Future.delayed(const Duration(seconds: 50));
      final response = await _coursesDataSource.getCourses(divisionId: divisionId);
      final modules = response.customData['modules'] as List;
      final units = response.customData['units'] as List;
      final chapters = response.customData['chapters'] as List;
      final exercises = response.customData['exercices'] as List;
      inspect(response);

      final allQuestions = exercises.map((e) => e['questions']).toList();
      final prodModules =
          modules.map((module) => MaterialModel.fromMap(module)).toList();
      // AppLogger.logInfo('Modules: $prodModules');

      final modulesImages =
          prodModules.map((module) => module.imageList).toList();
      final modulesGridImages =
          prodModules.map((module) => module.imageGrid).toList();
      final prodUnits = units.map((unit) => UnitModel.fromMap(unit)).toList();
      // AppLogger.logInfo('Units: $prodUnits');

      final prodChapters =
          chapters.map((chapter) => ChapterModel.fromMap(chapter)).toList();

      final prodExercises =
          allQuestions.expand((element) => element).toList().map((exercise) {
        return ExerciseModel.fromMap(exercise);
      }).toList();
      // AppLogger.logInfo('Exercises: $prodExercises');
      await ImagePrecacheService.cacheImages([
        ...modulesImages,
        ...modulesGridImages,
      ]);
      return DataResponse(
        modules: prodModules,
        units: prodUnits,
        chapters: prodChapters,
        exercises: prodExercises,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DataResponse(
          modules: [],
          units: [],
          chapters: [],
          exercises: [],
        );
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<SubmissionProgressResponse> submitAnswers(
    int chapterId,
    List<SubmissionAnswer> submissionAnswers,
  ) async {
    try {
      final response = await _coursesDataSource.submitAnswers(
        SubmitAnswerModel(
          chapterId: chapterId,
          submissionAnswers: submissionAnswers,
        ).toMap(),
      );
      return SubmissionProgressResponse.fromMap(
          response.customData['progress']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportExercise(int exerciseId, String? reason) async {
    try {
      await _coursesDataSource.reportExercise(
        ReportExoDto(exerciseId: exerciseId, reason: reason),
      );
    } catch (e) {
      AppLogger.logError('Error reporting exercise: $e');
      rethrow;
    }
  }
}
