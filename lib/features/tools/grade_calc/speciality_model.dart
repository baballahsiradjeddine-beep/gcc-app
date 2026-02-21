import 'package:tayssir/features/tools/grade_calc/subject.dart';

class SpecialityModel {
  final String name;
  final String iconPath;
  final List<Subject> subjects;

  const SpecialityModel({
    required this.name,
    required this.iconPath,
    required this.subjects,
  });
}
