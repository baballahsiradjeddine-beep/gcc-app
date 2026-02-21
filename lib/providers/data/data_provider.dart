import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/data/content_data.dart';
import 'package:tayssir/providers/data/data_state.dart';

import '../../features/exercice/presentation/state/exercise_state.dart';
import '../../services/course_service.dart';

final dataProvider = StateNotifierProvider<DataController, DataState>((ref) {
  final dataService = ref.watch(dataServiceProvider);
  return DataController(dataService);
});

class SubmissionExerciceModel {
  final int points;
  final int bonusPoints;
  final double bestProgress;

  SubmissionExerciceModel({
    required this.points,
    required this.bonusPoints,
    required this.bestProgress,
  });


  int get totalPoints {
    return points + bonusPoints;
  }
}

class DataController extends StateNotifier<DataState> {
  final DataService dataService;
  DataController(this.dataService) : super(const DataState()) {
    // getData();
  }
  Future<void> getData() async {
    await dataService.getCourses();
    state = state.setData(
      ContentData(
        modules: dataService.modules,
        units: dataService.units,
        chapters: dataService.chapters,
        exercises: dataService.exercises,
      ),
    );
  }

  // refresh data
  Future<void> refreshData() async {
    getData();
  }

  // submit answers
  Future<SubmissionExerciceModel> submitAnswers(
      List<SubmissionAnswer> answers, int chapterId) async {
    // if (state.isChapterAlreadySubmitted(chapterId)) return;
    final progress = await dataService.submitAnswers(
      answers,
      chapterId,
    );
    state = state.updateAllProgress(progress);
    final response = SubmissionExerciceModel(
      points: progress.chapter.points,
      bonusPoints: progress.chapter.bonusPoints!,
      bestProgress: progress.chapter.progress,
    );
    return response;

  }

  int getChapterBonusPoints(int chapterId) {
    return state.getChapterBonusPoints(chapterId);
  }
}
