class AnomallyWordState {
  final List<int> selectedAnswers;
  const AnomallyWordState({required this.selectedAnswers});

  bool isAnswerSelected(int answer) => selectedAnswers.contains(answer);

  factory AnomallyWordState.initial() {
    return const AnomallyWordState(selectedAnswers: []);
  }

  bool get canSubmit => selectedAnswers.isNotEmpty;
  AnomallyWordState copyWith({
    List<int>? selectedAnswers,
  }) {
    return AnomallyWordState(
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }

  AnomallyWordState clearSelectedAnswer() {
    return const AnomallyWordState(selectedAnswers: []);
  }
}
