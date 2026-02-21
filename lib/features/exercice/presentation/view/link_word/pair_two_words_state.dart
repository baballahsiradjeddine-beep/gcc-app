// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/pair_two_words_provider.dart';

class PairTwoWordsState extends Equatable {
  final int? selectedFirstIndex;
  final int? selectedSecondIndex;
  final Set<int> correctFirstIndices;
  final Set<int> correctSecondIndices;
  final Set<int> wrongFirstIndices;
  final Set<int> wrongSecondIndices;
  final Set<int> doneFirstIndices;
  final Set<int> doneSecondIndices;
  final bool isCompleted;
  final bool canClick;
  final int wrongAnswersCount;

  const PairTwoWordsState({
    this.selectedFirstIndex,
    this.selectedSecondIndex,
    this.correctFirstIndices = const {},
    this.correctSecondIndices = const {},
    this.wrongFirstIndices = const {},
    this.wrongSecondIndices = const {},
    this.doneFirstIndices = const {},
    this.doneSecondIndices = const {},
    this.isCompleted = false,
    this.canClick = true,
    this.wrongAnswersCount = 0,
  });

  PairTwoWordsState copyWith({
    Object? selectedFirstIndex = _noValue,
    Object? selectedSecondIndex = _noValue,
    Set<int>? correctFirstIndices,
    Set<int>? correctSecondIndices,
    Set<int>? wrongFirstIndices,
    Set<int>? wrongSecondIndices,
    Set<int>? doneFirstIndices,
    Set<int>? doneSecondIndices,
    bool? isCompleted,
    bool? canClick,
    int? wrongAnswersCount,
  }) {
    return PairTwoWordsState(
      selectedFirstIndex: selectedFirstIndex == _noValue
          ? this.selectedFirstIndex
          : selectedFirstIndex as int?,
      selectedSecondIndex: selectedSecondIndex == _noValue
          ? this.selectedSecondIndex
          : selectedSecondIndex as int?,
      correctFirstIndices: correctFirstIndices ?? this.correctFirstIndices,
      correctSecondIndices: correctSecondIndices ?? this.correctSecondIndices,
      wrongFirstIndices: wrongFirstIndices ?? this.wrongFirstIndices,
      wrongSecondIndices: wrongSecondIndices ?? this.wrongSecondIndices,
      doneFirstIndices: doneFirstIndices ?? this.doneFirstIndices,
      doneSecondIndices: doneSecondIndices ?? this.doneSecondIndices,
      isCompleted: isCompleted ?? this.isCompleted,
      canClick: canClick ?? this.canClick,
      wrongAnswersCount: wrongAnswersCount ?? this.wrongAnswersCount,
    );
  }

  static const _noValue = Object();

  PairTwoWordsState clearSelectedFirst() {
    return copyWith(selectedFirstIndex: null);
  }

  bool isFirstColumnWordSelected(int index) {
    return selectedFirstIndex == index;
  }

  bool isSecondColumnWordSelected(int index) {
    return selectedSecondIndex == index;
  }

  PairTwoWordsState disableClick() {
    return copyWith(canClick: false);
  }

  PairTwoWordsState enableClick() {
    return copyWith(canClick: true);
  }

  PairTwoWordsStatus getFirstStatus(int index) {
    if (doneFirstIndices.contains(index)) return PairTwoWordsStatus.done;
    if (correctFirstIndices.contains(index)) return PairTwoWordsStatus.correct;
    if (wrongFirstIndices.contains(index)) return PairTwoWordsStatus.wrong;
    if (selectedFirstIndex == index) return PairTwoWordsStatus.selected;
    return PairTwoWordsStatus.unselected;
  }

  PairTwoWordsStatus getSecondStatus(int index) {
    if (doneSecondIndices.contains(index)) return PairTwoWordsStatus.done;
    if (correctSecondIndices.contains(index)) return PairTwoWordsStatus.correct;
    if (wrongSecondIndices.contains(index)) return PairTwoWordsStatus.wrong;
    if (selectedSecondIndex == index) return PairTwoWordsStatus.selected;
    return PairTwoWordsStatus.unselected;
  }

  PairTwoWordsState clearSelected() {
    return PairTwoWordsState(
      selectedFirstIndex: null,
      selectedSecondIndex: null,
      correctFirstIndices: correctFirstIndices,
      correctSecondIndices: correctSecondIndices,
      wrongFirstIndices: wrongFirstIndices,
      wrongSecondIndices: wrongSecondIndices,
      doneFirstIndices: doneFirstIndices,
      doneSecondIndices: doneSecondIndices,
      isCompleted: isCompleted,
      canClick: canClick,
      wrongAnswersCount: wrongAnswersCount,
    );
  }

  PairTwoWordsState setFirstColumnWord(int index) {
    if (selectedFirstIndex == index) {
      return clearSelectedFirst();
    }
    if (!canClick) {
      return this;
    }
    return copyWith(selectedFirstIndex: index);
  }

  PairTwoWordsState setSecondColumnWord(int index) {
    if (selectedSecondIndex == index) {
      return copyWith(selectedSecondIndex: null);
    }
    if (!canClick) {
      return this;
    }
    return copyWith(selectedSecondIndex: index);
  }

  PairTwoWordsState clearWrong() {
    return copyWith(
      wrongFirstIndices: const {},
      wrongSecondIndices: const {},
    );
  }

  bool get canCheck =>
      selectedFirstIndex != null && selectedSecondIndex != null;

  int get allAnswers => doneFirstIndices.length;

  PairTwoWordsState incrementWrongAnswersCount() {
    return copyWith(wrongAnswersCount: wrongAnswersCount + 1);
  }

  bool isFirstSelectable(int index) {
    return !doneFirstIndices.contains(index);
  }

  bool isSecondSelectable(int index) {
    return !doneSecondIndices.contains(index);
  }

  @override
  List<Object?> get props {
    return [
      selectedFirstIndex,
      selectedSecondIndex,
      correctFirstIndices,
      correctSecondIndices,
      wrongFirstIndices,
      wrongSecondIndices,
      doneFirstIndices,
      doneSecondIndices,
      isCompleted,
      canClick,
      wrongAnswersCount,
    ];
  }

  @override
  bool get stringify => true;
}
