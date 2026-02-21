import 'package:flutter/material.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/pair_two_words_state.dart';
import 'package:tayssir/features/exercice/presentation/view/link_word/word_widget.dart';
import 'package:tayssir/providers/data/models/latex_field.dart';

class PairWordsColumn extends StatelessWidget {
  const PairWordsColumn({
    super.key,
    required this.words,
    required this.state,
    required this.onWordPressed,
    required this.isFirst,
  });

  final List<LatexField<String>> words;
  final PairTwoWordsState state;
  final Function(int) onWordPressed;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var word in words)
          WordWidget(
            onWordPressed: onWordPressed,
            word: word,
            state: state,
            index: words.indexOf(word),
            isFirst: isFirst,
          ),
      ],
    );
  }
}
