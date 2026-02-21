import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';

class TrueFalseExercise extends ExerciseModel {
  final LatexField<String> question;
  final bool correctAnswer;

  TrueFalseExercise({
    required this.question,
    required this.correctAnswer,
    required super.id,
    required super.points,
    required super.explanation,
    required super.hints,
    super.image,
    required super.chapterId,
    required super.direction,
    super.explanationVideo,
    required super.scope,
    // required super.difficulty,
    super.hintImage,
  }) : super(type: ExerciseType.trueFalse);

  factory TrueFalseExercise.fromMap(Map<String, dynamic> map) {
    final baseParams = map.asExerciseBaseParams;

    return TrueFalseExercise(
      id: baseParams.id,
      chapterId: baseParams.chapterId,
      points: baseParams.points,
      scope: baseParams.scope,
      // difficulty: baseParams.difficulty,
      direction: baseParams.direction,
      hints: baseParams.hints,
      hintImage: baseParams.hintImage,
      explanation: baseParams.explanation,
      image: baseParams.image,
      explanationVideo: baseParams.explanationVideo,
      question:
          LatexField<String>.fromMap(map['question'] as Map<String, dynamic>),
      correctAnswer: map['correctAnswer'] as bool,
    );
  }

  @override
  bool checkAnswer(dynamic answer) {
    return answer == correctAnswer;
  }

  @override
  dynamic getCorrectAnswer() {
    return correctAnswer;
  }

  @override
  String getFeedback() {
    String finalResult = '';
    if (explanation.text != null) {
      finalResult = explanation.text!;
    } else {
      finalResult = "الاجابة الصحيحة هي ${correctAnswer ? 'صحيح' : 'خطأ'}";
    }
    return finalResult;
  }
}
