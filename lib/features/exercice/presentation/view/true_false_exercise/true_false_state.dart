// state notifier for the true false exercise

class TrueFalseState {
  final bool? selectedAnswer;
  const TrueFalseState({required this.selectedAnswer});

  factory TrueFalseState.initial() {
    return const TrueFalseState(selectedAnswer: null);
  }

  bool get isFalsePicked => selectedAnswer == false;
  bool get isTruePicked => selectedAnswer == true;
  bool get canSubmit => selectedAnswer != null;
  TrueFalseState copyWith({
    bool? selectedAnswer,
  }) {
    return TrueFalseState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }

  // clearSelectedAnswer

  TrueFalseState clearSelectedAnswer() {
    return const TrueFalseState(selectedAnswer: null);
  }
}
