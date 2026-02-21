import 'package:equatable/equatable.dart';

class KnowOption extends Equatable {
  final String value;
  final String icon;

  const KnowOption({
    required this.value,
    required this.icon,
  });

  factory KnowOption.initial() {
    return const KnowOption(value: '', icon: '');
  }

  @override
  List<Object?> get props => [value, icon];
}
