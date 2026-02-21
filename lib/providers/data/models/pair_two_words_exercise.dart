import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';

class PairTwoWordsExercise extends ExerciseModel {
  final List<WordPair> correctAnswers;
  List<LatexField<String>> firstPairs = [];
  List<LatexField<String>> secondPairs = [];

  PairTwoWordsExercise(
      {required super.id,
      required this.correctAnswers,
      required super.chapterId,
      required super.scope,
      // required super.difficulty,
      required super.points,
      required super.direction,
      super.explanationVideo,
      required super.explanation,
      required super.hints,
      super.image,
      super.hintImage})
      : super(
          type: ExerciseType.pairTwoWords,
        ) {
    firstPairs = correctAnswers.map((e) => e.first).toList()..shuffle();
    secondPairs = correctAnswers.map((e) => e.second).toList()..shuffle();
  }

  factory PairTwoWordsExercise.fromMap(Map<String, dynamic> map) {
    final baseParams = map.asExerciseBaseParams;

    return PairTwoWordsExercise(
      id: baseParams.id,
      correctAnswers: List<WordPair>.from(
        (map['pairs'] as List<dynamic>).map((e) {
          return WordPair.fromMap(e);
        }),
      ),
      chapterId: baseParams.chapterId,
      points: baseParams.points,
      hints: baseParams.hints,
      explanation: baseParams.explanation,
      image: baseParams.image,
      explanationVideo: baseParams.explanationVideo,
      scope: baseParams.scope,
      direction: baseParams.direction,
      // difficulty: baseParams.difficulty,
      hintImage: baseParams.hintImage,
    );
  }

  @override
  bool checkAnswer(dynamic answer) {
    return true;
  }

  @override
  dynamic getCorrectAnswer() {
    return correctAnswers;
  }

  @override
  String getFeedback() {
    String finalResult = '';
    if (explanation.text != null) {
      finalResult = explanation.text!;
    } else {
      finalResult = correctAnswers
          .map((e) => '${e.first.text} - ${e.second.text}')
          .join('\n');
    }

    return finalResult;
  }
}

class WordPair extends Equatable {
  final LatexField<String> first;
  final LatexField<String> second;

  const WordPair(this.first, this.second);

  @override
  List<Object?> get props => [first, second];

  factory WordPair.fromMap(Map<String, dynamic> map) {
    return WordPair(
      LatexField<String>.fromMap(map['first'] as Map<String, dynamic>),
      LatexField<String>.fromMap(map['second'] as Map<String, dynamic>),
    );
  }

  @override
  bool? get stringify => true;
}
