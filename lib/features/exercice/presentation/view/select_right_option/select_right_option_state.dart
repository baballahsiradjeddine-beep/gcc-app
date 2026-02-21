class SelectRightOptionState {
  final List<String> selectedAnswers;
  const SelectRightOptionState({required this.selectedAnswers});

  factory SelectRightOptionState.initial() {
    return const SelectRightOptionState(selectedAnswers: []);
  }

  bool get canSubmit => selectedAnswers.isNotEmpty;
  SelectRightOptionState copyWith({
    List<String>? selectedAnswer,
  }) {
    return SelectRightOptionState(
      selectedAnswers: selectedAnswer ?? selectedAnswers,
    );
  }

  SelectRightOptionState clearSelectedAnswer() {
    return const SelectRightOptionState(selectedAnswers: []);
  }
}
