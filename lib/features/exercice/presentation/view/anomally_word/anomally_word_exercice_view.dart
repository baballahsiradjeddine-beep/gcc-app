import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/data/models/anomaly_word_exercise.dart';
import 'package:tayssir/features/exercice/presentation/view/anomally_word/anomally_word_exercice_controller.dart';
import 'package:tayssir/features/exercice/presentation/view/anomally_word/anomaly_word_widget.dart';

import '../fill_in_the_blank/exercise_template.dart';
import '../question_content_widget.dart';

class AnomallyWordExerciceView extends ConsumerWidget {
  const AnomallyWordExerciceView({
    super.key,
    required this.exercise,
  });

  final AnomalyWordExercise exercise;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = exercise.words;
    final correctWords = exercise.correctAnomalies;
    final state = ref.watch(anomallyWordNotifierProvider(exercise));
    return ExerciseTemplate(
      questionType: 'اختر العنصر المختلف',
      remark: exercise.remark,
      remarkImage: exercise.hintImage,
      imageUrl: exercise.image,
      useSpacerBeforeButton: true,
      useSpacerAfterQuestion: false,
      questionWidget: QuestionContentWidget(
        question: exercise.question,
      ),
      choices: [
        Wrap(
          alignment: WrapAlignment.start,
          textDirection: exercise.currentDirection,
          children: [
            for (var word in words)
              AnomalyWordWidget(
                word: word,
                fontSize: 20,
                isSelected: state.isAnswerSelected(words.indexOf(word)),
                onTap: () {
                  ref
                      .read(anomallyWordNotifierProvider(exercise).notifier)
                      .selectAnswer(words.indexOf(word));
                },
                isCorrectWord: correctWords.contains(words.indexOf(word)),
              )
          ],
        ),
      ],
      buttonText: 'تحقق',
      onButtonPressed: state.canSubmit
          ? () {
              ref
                  .read(anomallyWordNotifierProvider(exercise).notifier)
                  .submitAnswer(context);
            }
          : null,
    );
  }
}
