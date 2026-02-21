import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/data/content_data.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/data/models/unit_model.dart';
import 'package:tayssir/providers/data/progress_model.dart';
import 'package:tayssir/providers/data/submission_progress_response.dart';

import 'models/chapter_model.dart';
import 'models/exercise_model.dart';

class DataState extends Equatable {
  final ContentData contentData;
  const DataState({
    this.contentData = const ContentData(
      modules: [],
      units: [],
      chapters: [],
      exercises: [],
    ),
  });

  DataState copyWith({
    ContentData? contentData,
  }) {
    return DataState(
      contentData: contentData ?? this.contentData,
    );
  }

  DataState setData(ContentData contentData) {
    return DataState(contentData: contentData);
  }

  MaterialModel getMaterialById(int id) {
    return contentData.modules.firstWhere((element) => element.id == id);
  }

  List<String> get materialsAssets {
    return contentData.modules.map((e) => e.imageList).toList();
  }

  List<String> get materialsGridAssets {
    return contentData.modules.map((e) => e.imageGrid).toList();
  }

  List<String> get materialsAllAssets {
    return [
      ...materialsAssets,
      ...materialsGridAssets,
    ];
  }

  int get totalChapters {
    return contentData.chapters.length;
  }

  int get completedChapters {
    return contentData.chapters
        .where((element) => element.progress == 100)
        .length;
  }

  // get units by course id
  List<UnitModel> getUnitsByCourseId(int id) {
    return contentData.units
        .where((element) => element.materialId == id)
        .toList();
  }

  // get unit by id
  UnitModel getUnitById(int id) {
    return contentData.units.firstWhere((element) => element.id == id);
  }

  // get current unit by course id
  UnitModel getCurrentUnitByCourseId(int id) {
    final resultUnit = contentData.units.firstWhere(
        (element) => element.materialId == id && !element.isCompleted,
        orElse: () =>
            const UnitModel(id: -1, title: '', materialId: -1, progress: 0));

    if (resultUnit.id == -1) {
      return contentData.units.lastWhere((element) => element.materialId == id);
    }
    return resultUnit;
  }

  TextDirection getMaterialDirection(int id) {
    // return TextDirection.ltr;
    return getMaterialById(id).direction;
  }

  TextDirection getUnitDirection(int id) {
    // return TextDirection.ltr;
    return getUnitById(id).direction;
  }

  // same but for chapters
  ChapterModel getCurrentChapterByUnitId(int id, {bool isPro = false}) {
    final resultChapter = contentData.chapters.firstWhere(
        (element) =>
            element.unitId == id &&
            !element.isSubmitted &&
            (isPro || !(element.visibility == ChapterVisibility.premium)),
        orElse: () =>
            const ChapterModel(id: -1, title: '', unitId: -1, progress: 0));

    if (resultChapter.id == -1) {
      return contentData.chapters.lastWhere((element) => element.unitId == id);
    }
    return resultChapter;
  }

  // get all the user progress //  number of chapters  completed  // number of all chapters
  double get totalProgress {
    final allChapters = contentData.chapters.length;
    final completedChapters =
        contentData.chapters.where((element) => element.progress == 100).length;
    return completedChapters / allChapters;
  }

  // get chapter index  and convert to الفصل+ index
  String getUnitIndex(int courseId) {
    final unitId = getCurrentUnitByCourseId(courseId).id;
    final index = getUnitsByCourseId(courseId)
            .indexWhere((element) => element.id == unitId) +
        1;
    return 'المحور ${_convertToArabicOrdinal(index)}';
  }

  String getChapterIndex(int unitId) {
    final chapter = getCurrentChapterByUnitId(unitId);
    final chapterId = chapter.id;
    final index = getChaptersByUnitId(unitId)
            .indexWhere((element) => element.id == chapterId) +
        1;
    return 'الفصل ${_convertToArabicOrdinal(index)}';
  }

  bool isCompletedUnit(int unitId) {
    final current =
        contentData.units.firstWhere((element) => element.id == unitId);
    return current.isCompleted;
  }

  bool isCompletedMaterial(int materialId) {
    final current =
        contentData.modules.firstWhere((element) => element.id == materialId);
    return current.progress == 100;
  }

  bool isLockedChapter(int unitId, int chapterId, bool isPro) {
    // if (isCompletedUnit(unitId)) {
    // return false;
    // }
    // if my progress in this chapter is at least > 0
    final chapter =
        contentData.chapters.firstWhere((element) => element.id == chapterId);
    if (chapter.progress > 0) {
      return false;
    }

    //TODO:need to be tested
    final current = getCurrentChapterByUnitId(
      unitId,
      isPro: isPro,
    );
    // AppLogger.logInfo('current chapter for  $unitId ${current.id}');
    final currentIndex = getChapterIndexById(current.id);
    final index = getChapterIndexById(chapterId);
    // if (current.id >= chapterId) {
    //   return false;
    // }
    // check by index
    if (currentIndex >= index) {
      return false;
    }

    return true;
    // if (current.id >= chapterId) {
    //   return false;
    // }
    // return true;
  }

  // get  chapter index by id
  int getChapterIndexById(int chapterId) {
    return contentData.chapters
        .indexWhere((element) => element.id == chapterId);
  }

  bool isLockedUnit(int courseId, int unitId) {
    if (isCompletedMaterial(courseId)) {
      return false;
    }
    final current = getCurrentUnitByCourseId(courseId);
    if (current.id >= unitId) {
      return false;
    }
    return true;
  }

  ChapterModel getChapterById(int id) {
    return contentData.chapters.firstWhere((element) => element.id == id);
  }

  bool isCurrentCHapter(int chapterId, int unitId, bool isPro) {
    final currentChapter = getCurrentChapterByUnitId(unitId, isPro: isPro);
    // AppLogger.logInfo('current chapter for  $unitId ${currentChapter.id}');

    if (currentChapter.id == -1) {
      return false;
    }
    return currentChapter.id == chapterId;
  }

  bool isCurrentUnit(int unitId, int courseId) {
    final currentUnit = contentData.units.firstWhere(
        (element) => element.materialId == courseId && element.progress < 50,
        orElse: () =>
            const UnitModel(id: -1, title: '', materialId: -1, progress: 0));
    if (currentUnit.id == -1) {
      return false;
    }
    return currentUnit.id == unitId;
  }

  String _convertToArabicOrdinal(int number) {
    switch (number) {
      case 1:
        return 'الأول';
      case 2:
        return 'الثاني';
      case 3:
        return 'الثالث';
      case 4:
        return 'الرابع';
      case 5:
        return 'الخامس';
      case 6:
        return 'السادس';
      case 7:
        return 'السابع';
      case 8:
        return 'الثامن';
      case 9:
        return 'التاسع';
      case 10:
        return 'العاشر';
      default:
        return number.toString();
    }
  }

// get chapters by unit id
  List<ChapterModel> getChaptersByUnitId(int id) {
    return contentData.chapters
        .where((element) => element.unitId == id)
        .toList();
  }

// get exercises by chapter id
  List<ExerciseModel> getExercisesByChapterId(int id) {
    return contentData.exercises
        .where((element) => element.chapterId == id)
        .toList();
  }

  DataState setChapterProgress(ProgressModel progress) {
    final newChapters = List<ChapterModel>.from(contentData.chapters);
    final index =
        newChapters.indexWhere((chapter) => chapter.id == progress.id);

    if (index != -1) {
      newChapters[index] = newChapters[index].setProgress(progress.progress);
    }

    return copyWith(
      contentData: contentData.copyWith(
        chapters: newChapters,
      ),
    );
  }

  // same for unit
  DataState setUnitProgress(ProgressModel progress) {
    final newUnits = List<UnitModel>.from(contentData.units);
    final index = newUnits.indexWhere((unit) => unit.id == progress.id);
    if (index != -1) {
      newUnits[index] = newUnits[index].setProgress(progress.progress);
    }

    return copyWith(
      contentData: contentData.copyWith(
        units: newUnits,
      ),
    );
  }

  // same for material
  DataState setMaterialProgress(ProgressModel progress) {
    final newMaterials = List<MaterialModel>.from(contentData.modules);
    final index =
        newMaterials.indexWhere((material) => material.id == progress.id);
    if (index != -1) {
      newMaterials[index] = newMaterials[index].setProgress(progress.progress);
    }

    return copyWith(
      contentData: contentData.copyWith(
        modules: newMaterials,
      ),
    );
  }

  DataState updateAllProgress(SubmissionProgressResponse progress) {
    DataState updatedState = this;

    updatedState = updatedState.setChapterProgress(progress.chapter);

    updatedState = updatedState.setUnitProgress(progress.unit);

    updatedState = updatedState.setMaterialProgress(progress.material);

    return updatedState;
  }

  bool isChapterAlreadySubmitted(int chapterId) {
    final chapter =
        contentData.chapters.firstWhere((element) => element.id == chapterId);
    return chapter.isSubmitted;
  }

  int getChapterBonusPoints(int chapterId) {
    final chapter =
        contentData.chapters.firstWhere((element) => element.id == chapterId);
    return chapter.bonusPoints;
  }

  bool isPremiumUnit(int unitId) {
    final unit =
        contentData.units.firstWhere((element) => element.id == unitId);
    return unit.visibility == UnitVisibility.premium;
  }

  bool isPremiumChapter(int chapterId) {
    final chapter =
        contentData.chapters.firstWhere((element) => element.id == chapterId);
    return chapter.visibility == ChapterVisibility.premium;
  }

  ChapterVisibility getChapterVisibility(int chapterId) {
    final chapter =
        contentData.chapters.firstWhere((element) => element.id == chapterId);
    return chapter.visibility;
  }

  @override
  List<Object?> get props => [contentData];
}
