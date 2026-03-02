class Blank {
  // final LatexField<String> correctWord;
  final String correctWord;
  final int position;

  Blank({
    required this.correctWord,
    required this.position,
  });

  factory Blank.fromMap(Map<String, dynamic> map) {
    return Blank(
      // correctWord: LatexField<String>.fromMap(
      //     map['correct_word'] as Map<String, dynamic>),
      correctWord: map['correct_word'] as String,
      position:
          // if its int then put , if its string then parse to int
          map['position'] is int
              ? map['position'] as int
              : int.parse(map['position'] as String),
    );
  }
}
