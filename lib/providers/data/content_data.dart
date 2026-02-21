import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/data/models/chapter_model.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/data/models/unit_model.dart';

class ContentData extends Equatable {
  final List<MaterialModel> modules;
  final List<UnitModel> units;
  final List<ChapterModel> chapters;
  final List<ExerciseModel> exercises;

  const ContentData({
    required this.modules,
    required this.units,
    required this.chapters,
    required this.exercises,
  });

  //empty
  ContentData.empty()
      : modules = [],
        units = [],
        chapters = [],
        exercises = [];

  ContentData copyWith({
    List<MaterialModel>? modules,
    List<UnitModel>? units,
    List<ChapterModel>? chapters,
    List<ExerciseModel>? exercises,
  }) {
    return ContentData(
      modules: modules ?? this.modules,
      units: units ?? this.units,
      chapters: chapters ?? this.chapters,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [modules, units, chapters, exercises];
}
