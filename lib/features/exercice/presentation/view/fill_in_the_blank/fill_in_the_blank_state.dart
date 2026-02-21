import 'package:equatable/equatable.dart';
import 'package:tayssir/providers/data/models/fill_in_the_blank_exercise.dart';

class FillInTheBlankState extends Equatable {
  final FillInTheBlankExercise exercise;
  final List<String?> filledBlanks;
  final List<bool> wordSelectionState;
  final bool isChecked;
  final bool isCorrect;

  const FillInTheBlankState({
    required this.exercise,
    required this.filledBlanks,
    required this.wordSelectionState,
    this.isChecked = false,
    this.isCorrect = false,
  });

  FillInTheBlankState copyWith({
    FillInTheBlankExercise? exercise,
    List<String?>? filledBlanks,
    List<bool>? wordSelectionState,
    bool? isChecked,
    bool? isCorrect,
  }) {
    return FillInTheBlankState(
      exercise: exercise ?? this.exercise,
      filledBlanks: filledBlanks ?? this.filledBlanks,
      wordSelectionState: wordSelectionState ?? this.wordSelectionState,
      isChecked: isChecked ?? this.isChecked,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  int getFirstUnfilledBlankIndex() {
    return filledBlanks.indexWhere((blank) => blank == null);
  }

  bool isAllBlanksFilled() {
    return filledBlanks.every((blank) => blank != null);
  }

  bool isAllWordsSelected() {
    return wordSelectionState.every((isSelected) => isSelected);
  }

  bool isWordSelected(int wordIndex) {
    return wordSelectionState[wordIndex];
  }

  bool get canSubmit => isAllBlanksFilled();

  bool checkAnswer() {
    final blanks = exercise.blanks;
    for (int i = 0; i < blanks.length; i++) {
      //todo FITB
      if (blanks[i].correctWord != filledBlanks[i]) {
        return false;
      }
    }
    return true;
  }

  bool isAnswered(int blankIndex) => filledBlanks[blankIndex] != null;
  String getBlankAnswer(int blankIndex) =>
      filledBlanks[blankIndex] ?? List.filled(5, "_").join("");

  bool isCorrectWord(int blankIndex) {
    //todo FITB
    return exercise.blanks[blankIndex].correctWord == filledBlanks[blankIndex];
  }

  @override
  List<Object?> get props =>
      [exercise, filledBlanks, wordSelectionState, isChecked, isCorrect];

  @override
  String toString() {
    return 'FillInTheBlankState(exercise: $exercise, filledBlanks: $filledBlanks, wordSelectionState: $wordSelectionState, isChecked: $isChecked, isCorrect: $isCorrect)';
  }
}
