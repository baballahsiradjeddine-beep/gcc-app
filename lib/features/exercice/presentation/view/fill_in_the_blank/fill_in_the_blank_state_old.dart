// import 'package:equatable/equatable.dart';
// import 'package:tayssir/features/exercice/presentation/view/fill_in_the_blank/blank_word.dart';
// import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';

// class FillInTheBlankState extends Equatable {
//   final FillInTheBlankExercise exercise;
//   final List<String?> userAnswers;
//   final List<BlankWord> suggestions;

//   const FillInTheBlankState({
//     required this.exercise,
//     required this.userAnswers,
//     required this.suggestions,
//   });

//   FillInTheBlankState copyWith({
//     FillInTheBlankExercise? exercise,
//     List<String?>? userAnswers,
//     List<BlankWord>? suggestions,
//   }) {
//     return FillInTheBlankState(
//       exercise: exercise ?? this.exercise,
//       userAnswers: userAnswers ?? this.userAnswers,
//       suggestions: suggestions ?? this.suggestions,
//     );
//   }

//   @override
//   List<Object?> get props => [exercise, userAnswers, suggestions];

//   bool isEmptyWord(int index) {
//     return userAnswers[index] == null;
//   }

//   bool isAnswerCorrect() {
//     return exercise.checkAnswer(userAnswers);
//   }

//   int get currentSelectedWordIndex {
//     return userAnswers.indexWhere((element) => element != null);
//   }

//   String getCurrentSentence() {
//     var parts = exercise.sentence.split(' ');

//     for (var blank in exercise.blanks) {
//       if (userAnswers[currentSelectedWordIndex] != null) {
//         parts[blank.position] = userAnswers[currentSelectedWordIndex]!;
//       }
//     }
//     return parts.join(' ');
//   }
// }
