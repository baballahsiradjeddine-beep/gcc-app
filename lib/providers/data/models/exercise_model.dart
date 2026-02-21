import 'dart:developer';
import 'dart:ui';

import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/data/models/anomaly_word_exercise.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';
import 'package:tayssir/providers/data/models/pair_two_words_exercise.dart';
import 'package:tayssir/providers/data/models/select_multiple_option_exercise.dart';
import 'package:tayssir/providers/data/models/true_false_exercise.dart';

enum ExerciseType {
  multipleChoices,
  trueFalse,
  pairTwoWords,
  fillInTheBlank,
  anomalyWord,
}

enum ExerciseDirection {
  rtl,
  ltr,
}

enum ExerciseDifficulty { easy, medium, hard }

enum ExerciseScope {
  exercice,
  lesson,
}

abstract class ExerciseModel {
  final int id;
  final ExerciseType type;
  final int chapterId;
  final List<LatexField<String>> hints;
  final LatexField<String?> explanation;
  final String? image;
  final int points;
  // final ExerciseDifficulty difficulty;
  final ExerciseScope scope;
  final String? hintImage;
  final String? explanationVideo;
  final ExerciseDirection direction;

  ExerciseModel({
    required this.id,
    required this.type,
    required this.chapterId,
    required this.hints,
    required this.explanation,
    this.hintImage,
    // required this.difficulty,
    required this.points,
    required this.scope,
    required this.direction,
    this.image,
    this.explanationVideo,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    switch (map['type'] as String) {
      case 'multiple_choices':
        return SelectMultipleOptionExercise.fromMap(map);
      case 'true_or_false':
        return TrueFalseExercise.fromMap(map);
      case 'match_with_arrows':
        return PairTwoWordsExercise.fromMap(map);
      case 'fill_in_the_blanks':
        return FillInTheBlankExercise.fromMap(map
//           {
//             "id": 347,
//             "type": "fill_in_the_blanks",
//             "chapter_id": 120,
//             "image": null,
//             "difficulty": "medium",
//             "points": 5,
//             "scope": "lesson",
//             "hint": [],
//             "explanation_text": {"value": null, "is_latex": false},
//             "explanationVideo": null,
//             "hintImage": null,
//             "question": {
//               "value": """
// <p>
// أكمل: التركيز الكتلي لمحلول يُرمز له بـ ([1]) ويحسب بالعلاقة ([2] = \frac{m}{V})
// </p>
// """,
//               "is_latex": false
//             },
//             "direction": "RTL",
//             "paragraph": {
//               "value": """
// <p>
// أكمل: التركيز الكتلي لمحلول يُرمز له بـ ([1]) ويحسب بالعلاقة ([2] = \frac{m}{V})
// </p>
// """,
//               "is_latex": false
//             },
//             "blanks": [
//               {
//                 "correct_word": {
//                   "value": "التكتلات والمشاريع",
//                   "is_latex": false
//                 },
//                 "position": 1
//               },
//               {
//                 "correct_word": {
//                   "value": "القواعد والأحلاف",
//                   "is_latex": false
//                 },
//                 "position": 2
//               },
//               {
//                 "correct_word": {"value": "الجوسسة", "is_latex": false},
//                 "position": 3
//               }
//             ],
//             "suggestions": [
//               {"value": "التكتلات والمشاريع", "is_latex": false},
//               {"value": "القواعد والأحلاف", "is_latex": false},
//               {"value": "الجوسسة", "is_latex": false},
//               {"value": "التعاون الثقافي", "is_latex": false},
//               {"value": "المساعدات الإنسانية", "is_latex": false},
//               {"value": "المفاوضات المباشرة", "is_latex": false}
//             ]
//           },
            );
      case "pick_the_intruder":
        return AnomalyWordExercise.fromMap(map);
      default:
        throw Exception('Invalid exercise type');
    }
  }

  List<LatexField<String>>? get remark =>
      scope == ExerciseScope.lesson ? hints : null;

  bool get shouldShowHint =>
      hints.isNotEmpty && scope == ExerciseScope.exercice;

  TextDirection get currentDirection => direction == ExerciseDirection.rtl
      ? TextDirection.rtl
      : TextDirection.ltr;

  bool checkAnswer(dynamic answer);
  dynamic getCorrectAnswer();
  String getFeedback();
}

extension ExerciseMapExtension on Map<String, dynamic> {
  ExerciseBaseParams get asExerciseBaseParams {
    try {
      return ExerciseBaseParams(
        id: this['id'] as int,
        chapterId: this['chapter_id'] as int,
        points: this['points'] as int,
        hints: List<LatexField<String>>.from(
            (this['hint'] as List<dynamic>).map((e) {
          return LatexField<String>.fromMap(e);
        })),
        explanation: LatexField<String?>.fromMap(
            this['explanation_text'] as Map<String, dynamic>),
        image: this['image'] as String?,
        explanationVideo: this['explanationVideo'] as String?,
        scope: this['scope'] == 'lesson'
            ? ExerciseScope.lesson
            : ExerciseScope.exercice,
        // difficulty: this['difficulty'] == 'easy'
        // ? ExerciseDifficulty.easy
        // : this['difficulty'] == 'medium'
        // ? ExerciseDifficulty.medium
        // : ExerciseDifficulty.hard,
        direction: this['direction'] == 'RTL'
            ? ExerciseDirection.rtl
            : ExerciseDirection.ltr,
        hintImage: this['hintImage'] as String?,
      );
    } catch (e) {
      log('Error parsing exo Id: ${this['id']} - $e');
      // rethrow;
      return ExerciseBaseParams(
        id: -1,
        chapterId: -1,
        points: 0,
        hints: [],
        explanation: LatexField<String?>(false, 'val'),
        scope: ExerciseScope.exercice,
        direction: ExerciseDirection.ltr,
      );
    }
  }
}

class ExerciseBaseParams {
  final int id;
  final int chapterId;
  final List<LatexField<String>> hints;
  final LatexField<String?> explanation;
  final String? image;
  final int points;
  // final ExerciseDifficulty difficulty;
  final ExerciseScope scope;
  final String? hintImage;
  final String? explanationVideo;
  final ExerciseDirection direction;

  ExerciseBaseParams({
    required this.id,
    required this.chapterId,
    required this.points,
    required this.scope,
    // required this.difficulty,
    required this.direction,
    required this.explanation,
    required this.hints,
    this.image,
    this.hintImage,
    this.explanationVideo,
  });
}
