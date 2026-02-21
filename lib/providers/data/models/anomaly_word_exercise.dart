import 'package:flutter/foundation.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';

class AnomalyWordExercise extends ExerciseModel {
  final List<LatexField<String>> words;
  final List<int> correctAnomalies;
  final LatexField<String> question;
  AnomalyWordExercise({
    required super.id,
    required this.words,
    required this.correctAnomalies,
    required this.question,
    required super.chapterId,
    required super.direction,
    required super.points,
    required super.scope,
    // required super.difficulty,
    required super.explanation,
    required super.hints,
    super.image,
    super.explanationVideo,
    super.hintImage,
  }) : super(
          type: ExerciseType.anomalyWord,
        );

  factory AnomalyWordExercise.fromMap(Map<String, dynamic> map) {
    final baseParams = map.asExerciseBaseParams;

    return AnomalyWordExercise(
      id: baseParams.id,
      words: List<LatexField<String>>.from(
        (map['words'] as List<dynamic>).map((e) {
          return LatexField<String>.fromMap(e);
        }),
      ),
      correctAnomalies:
          List<int>.from(map['correctAnomalies'] as List<dynamic>),
      question:
          LatexField<String>.fromMap(map['question'] as Map<String, dynamic>),
      chapterId: baseParams.chapterId,
      points: baseParams.points,
      scope: baseParams.scope,
      // difficulty: baseParams.difficulty,
      direction: baseParams.direction,
      hints: baseParams.hints,
      explanation: baseParams.explanation,
      image: baseParams.image,
      explanationVideo: baseParams.explanationVideo,
      hintImage: baseParams.hintImage,
    );
  }

  @override
  bool checkAnswer(dynamic answer) {
    return listEquals(answer, correctAnomalies);
  }

  @override
  dynamic getCorrectAnswer() {
    return correctAnomalies;
  }

  @override
  String getFeedback() {
    String finalResult = '';
    if (explanation.text != null) {
      finalResult = explanation.text!;
    }
    {
      final resultAnswer = correctAnomalies.map((e) => words[e].text).toList();
      finalResult = resultAnswer.join(', ');
    }

    // return ' الإجابة الصحيحة هي \n$finalResult';
    return finalResult;
  }
}
