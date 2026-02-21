import 'package:equatable/equatable.dart';
import 'package:tayssir/features/tools/grade_calc/speciality_model.dart';
import 'package:tayssir/features/tools/grade_calc/state/subject_state.dart';

class GradeState extends Equatable {
  final SpecialityModel speciality;
  final List<SubjectState> subjects;

  const GradeState({required this.speciality, required this.subjects});

  GradeState copyWith({
    SpecialityModel? speciality,
    List<SubjectState>? subjects,
  }) {
    return GradeState(
      speciality: speciality ?? this.speciality,
      subjects: subjects ?? this.subjects,
    );
  }

  int get subjectCofficient {
    return speciality.subjects.fold<int>(
        0, (previousValue, element) => previousValue + element.coefficient);
  }

  int getCofficientOfSubject(int subjectId) {
    final subject =
        speciality.subjects.firstWhere((element) => element.id == subjectId);
    return subject.coefficient;
  }

  String getSubjectName(int subjectId) {
    final subject =
        speciality.subjects.firstWhere((element) => element.id == subjectId);
    return subject.name;
  }

  double get average {
    final total = subjects.fold<double>(
        0,
        (previousValue, element) =>
            previousValue +
            element.grade * getCofficientOfSubject(element.subjectId));
    return total / subjectCofficient;
  }

  bool get isPassing => average >= 10;

  GradeState updateGrade(int subjectId, double grade) {
    final subjectIndex =
        subjects.indexWhere((element) => element.subjectId == subjectId);
    if (subjectIndex == -1) {
      return this;
    }
    final newSubjects = List<SubjectState>.from(subjects);
    newSubjects[subjectIndex] =
        newSubjects[subjectIndex].copyWith(grade: grade);
    return copyWith(subjects: newSubjects);
  }

  @override
  List<Object?> get props => [speciality, subjects];
}
