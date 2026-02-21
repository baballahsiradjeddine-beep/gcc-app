import 'package:equatable/equatable.dart';

class SubjectState extends Equatable {
  final int subjectId;
  final double grade;

  const SubjectState({
    required this.subjectId,
    required this.grade,
  });

  SubjectState copyWith({
    int? subjectId,
    double? grade,
  }) {
    return SubjectState(
      subjectId: subjectId ?? this.subjectId,
      grade: grade ?? this.grade,
    );
  }

  @override
  List<Object?> get props => [subjectId, grade];
}
