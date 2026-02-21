import 'package:tayssir/providers/data/models/chapter_model.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/data/models/unit_model.dart';

class DataResponse {
  final List<MaterialModel> modules;
  final List<UnitModel> units;
  final List<ChapterModel> chapters;
  final List<ExerciseModel> exercises;

  DataResponse({
    required this.modules,
    required this.units,
    required this.chapters,
    required this.exercises,
  });
}
