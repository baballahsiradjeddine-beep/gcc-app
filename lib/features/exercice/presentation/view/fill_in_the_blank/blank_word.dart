
import 'blank_word_status.dart';

class BlankWord {
  final String word;
  final BlankWordStatus status;
  BlankWord({
    required this.word,
    this.status = BlankWordStatus.unselected,
  });

  BlankWord copyWith({
    String? word,
    BlankWordStatus? status,
  }) {
    return BlankWord(
      word: word ?? this.word,
      status: status ?? this.status,
    );
  }
}
