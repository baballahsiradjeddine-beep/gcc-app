import 'dart:developer';

class LatexField<T> {
  final bool isLatex;
  final T text;

  LatexField(this.isLatex, this.text);

  // String get cleanText => text.toString().replaceAll(RegExp(r'\$'), '');
  String get cleanText => text.toString();
  // .replaceAll('(', 'temp')
  // .replaceAll(')', '(')
  // .replaceAll('temp', ')');
  //     .replaceAll(RegExp(r'\$'), '');

  factory LatexField.fromMap(Map<String, dynamic> map) {
    try {
      return LatexField(
        map['is_latex'] as bool,
        map['value'] as T,
      );
    } catch (e) {
      log('value:${map['value']}');
      // return LatexField(false, map['value']);
      rethrow;
    }
  }
}
