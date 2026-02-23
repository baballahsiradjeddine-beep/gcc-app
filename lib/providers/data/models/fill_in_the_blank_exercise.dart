import 'package:tayssir/providers/data/models/blank.dart';
import 'package:tayssir/providers/data/models/exercise_model.dart';

class FillInTheBlankExercise extends ExerciseModel {
  // final LatexField<String> sentence;
  final List<Blank> blanks;
  // final List<LatexField<String>> suggestions;
  final String sentence;
  final List<String> suggestions;

  FillInTheBlankExercise({
    required super.id,
    required this.sentence,
    required this.blanks,
    required this.suggestions,
    required super.chapterId,
    required super.scope,
    // required super.difficulty,
    required super.points,
    required super.direction,
    required super.explanation,
    required super.hints,
    super.image,
    super.explanationVideo,
    super.hintImage,
  }) : super(
          type: ExerciseType.fillInTheBlank,
        );

  factory FillInTheBlankExercise.fromMap(Map<String, dynamic> map) {
    final baseParams = map.asExerciseBaseParams;

    return FillInTheBlankExercise(
      id: baseParams.id,
      chapterId: baseParams.chapterId,
      points: baseParams.points,
      scope: baseParams.scope,
      // difficulty: baseParams.difficulty,
      direction: baseParams.direction,
      hints: baseParams.hints,
      explanation: baseParams.explanation,
      image: baseParams.image,
      explanationVideo: baseParams.explanationVideo,
      //TODO: will redo this later on and update the logic of the controller and use this [number] instead of _____  because its better
      // sentence: LatexField<String>(
      //   map['is_latex'] as bool? ?? false,
      //   (map['paragraph']['value'] as String).replaceAllMapped(
      //     RegExp(r'\[\d+\]'),
      //     (match) => '_____',
      //   ),
      // ),
      // blanks: List<Blank>.from(
      //   (map['blanks'] as List<dynamic>).map((e) => Blank.fromMap(e)),
      // ),
      // // suggestions: List<String>.from(
      // //   (map['suggestions'] as List<dynamic>).map((e) => e['value'] as String),
      // // ),
      // suggestions: List<LatexField<String>>.from(
      //   (map['suggestions'] as List<dynamic>).map(
      //     (e) => LatexField<String>.fromMap(e),
      //   ),
      // ),
      // refectoring to the old way
      suggestions: List<String>.from(
        (map['suggestions'] as List<dynamic>).map((e) => e as String),
      ),
      blanks: List<Blank>.from(
        (map['blanks'] as List<dynamic>).map((e) => Blank.fromMap(e)),
      ),
      sentence: (map['paragraph'] as String).replaceAllMapped(
        RegExp(r'\[\d+\]'),
        (match) => '_____',
      ),
      hintImage: baseParams.hintImage,
    );
  }

  // Factory method to create a dummy exercise for testing
  // factory FillInTheBlankExercise.dummy() {
  //   return FillInTheBlankExercise(
  //     id: 1, // dummy id
  //     sentence: "القرآن الكريم هو [1] الله و [2] المبين",
  //     blanks: [
  //       Blank(correctWord: "كتاب", position: 0),
  //       Blank(correctWord: "نور", position: 1),
  //     ],
  //     suggestions: ["كتاب", "نور", "رسول", "كلام", "هدى"],
  //     chapterId: 1,
  //     scope: ExerciseScope.lesson,
  //     difficulty: ExerciseDifficulty.easy,
  //     points: 5,
  //     hint: ["تذكر أن القرآن هو ما أنزله الله على نبيه محمد"],
  //     explanation:
  //         "القرآن الكريم هو كتاب الله ونور المبين الذي أنزله على نبيه محمد",
  //   );
  // }

  @override
  bool checkAnswer(dynamic answer) {
    return answer == true;
  }

  @override
  dynamic getCorrectAnswer() {
    return blanks.map((e) => e.correctWord).toList();
  }

  @override
  String getFeedback() {
    String finalResult = '';
    if (explanation.text != null) {
      finalResult = explanation.text!;
    } else {
      final correctAnswers = getCorrectAnswer() as List<String>;
      finalResult = correctAnswers.join(', ');
    }

    // return 'الإجابة الصحيحة هي \n$finalResult';
    return finalResult;
  }
}
