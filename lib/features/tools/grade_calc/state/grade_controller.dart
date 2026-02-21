import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/tools/grade_calc/state/grade_state.dart';
import 'package:tayssir/features/tools/grade_calc/speciality_model.dart';
import 'package:tayssir/features/tools/grade_calc/subject.dart';
import 'package:tayssir/features/tools/grade_calc/state/subject_state.dart';

import '../../../../resources/resources.dart';

final gradeControllerProvider =
    StateNotifierProvider.family<GradeController, GradeState, SpecialityModel>(
        (ref, speciality) {
  return GradeController(
    speciality,
  );
});

class GradeController extends StateNotifier<GradeState> {
  GradeController(
    SpecialityModel speciality,
  ) : super(GradeState(
          speciality: speciality,
          subjects: speciality.subjects
              .map((e) => SubjectState(subjectId: e.id, grade: 0))
              .toList(),
        ));

  void updateGrade(int subjectId, double grade) {
    if (grade < 0 || grade > 20) {
      return;
    }
    // if (state.subjects
    //         .firstWhere((element) => element.subjectId == subjectId)
    //         .grade ==
    //     grade) {
    //   return;
    // }
    state = state.updateGrade(subjectId, grade);
  }

  void reset() {
    state = GradeState(
      speciality: state.speciality,
      subjects: state.subjects
          .map((e) => SubjectState(subjectId: e.subjectId, grade: 0))
          .toList(),
    );
  }
}

final specialityProvider = Provider<List<SpecialityModel>>((ref) {
  return [
    const SpecialityModel(
      name: 'رياضيات',
      iconPath: SVGs.icMath,
      subjects: [
        Subject(id: 1, name: 'الرياضيات', coefficient: 7),
        Subject(id: 2, name: 'الفيزياء', coefficient: 6),
        Subject(id: 3, name: 'العربية', coefficient: 3),
        Subject(id: 4, name: 'الفرنسية', coefficient: 2),
        Subject(id: 5, name: 'اجتماعيات', coefficient: 2),
        Subject(id: 7, name: 'الفلسفة', coefficient: 2),
        Subject(id: 8, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 9, name: 'علوم تجريبية', coefficient: 2),
        Subject(id: 10, name: 'الانجليزية', coefficient: 2),
        Subject(id: 11, name: 'الرياضة', coefficient: 1),
      ],
    ),
    // 2. علوم تجريبية (Experimental Sciences)
    const SpecialityModel(
      name: 'علوم تجريبية',
      iconPath: SVGs.icScience,
      subjects: [
        Subject(id: 1, name: 'العلوم الطبيعية', coefficient: 6),
        Subject(id: 2, name: 'الرياضيات', coefficient: 5),
        Subject(id: 3, name: 'الفيزياء', coefficient: 5),
        Subject(id: 4, name: 'العربية', coefficient: 3),
        Subject(id: 5, name: 'الفرنسية', coefficient: 2),
        Subject(id: 6, name: 'الانجليزية', coefficient: 2),
        Subject(id: 7, name: 'اجتماعيات', coefficient: 2),
        Subject(id: 8, name: 'الفلسفة', coefficient: 2),
        Subject(id: 9, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 10, name: 'الرياضة', coefficient: 1),
      ],
    ),
    // 3. تقني رياضي (Technical Mathematics)
    const SpecialityModel(
      name: 'تقني رياضي',
      iconPath: SVGs.icMathTechnique,
      subjects: [
        Subject(id: 1, name: 'الرياضيات', coefficient: 6),
        Subject(id: 2, name: 'الفيزياء', coefficient: 6),
        Subject(id: 3, name: 'التكنولوجيا', coefficient: 7),
        Subject(id: 4, name: 'العربية', coefficient: 3),
        Subject(id: 5, name: 'الفرنسية', coefficient: 2),
        Subject(id: 6, name: 'الانجليزية', coefficient: 2),
        Subject(id: 7, name: 'اجتماعيات', coefficient: 2),
        Subject(id: 8, name: 'الفلسفة', coefficient: 2),
        Subject(id: 9, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 10, name: 'الرياضة', coefficient: 1),
      ],
    ),
    // 4. آداب وفلسفة (Literature and Philosophy)
    const SpecialityModel(
      name: 'آداب وفلسفة',
      iconPath: SVGs.icPhilo,
      subjects: [
        Subject(id: 1, name: 'الفلسفة', coefficient: 6),
        Subject(id: 2, name: 'العربية', coefficient: 6),
        Subject(id: 5, name: 'اجتماعيات', coefficient: 4),
        Subject(id: 3, name: 'الفرنسية', coefficient: 3),
        Subject(id: 4, name: 'الانجليزية', coefficient:3),
        Subject(id: 6, name: 'الرياضيات', coefficient: 2),
        Subject(id: 7, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 8, name: 'الرياضة', coefficient: 1),
      ],
    ),
    const SpecialityModel(
      name: 'لغات أجنبية',
      iconPath: SVGs.icLangues,
      subjects: [
        Subject(id: 1, name: 'العربية', coefficient: 5),
        Subject(id: 2, name: 'الفرنسية', coefficient: 5),
        Subject(id: 3, name: 'الانجليزية', coefficient: 5),
        Subject(
            id: 4,
            name: 'لغة أجنبية ثالثة (الإسبانية/الألمانية/الإيطالية)',
            coefficient: 5),
        Subject(id: 5, name: 'الفلسفة', coefficient: 2),
        Subject(id: 6, name: 'اجتماعيات', coefficient: 2),
        Subject(id: 7, name: 'الرياضيات', coefficient: 2),
        Subject(id: 8, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 9, name: 'الرياضة', coefficient: 1),
      ],
    ),
    // 6. تسيير واقتصاد (Management and Economy)
    const SpecialityModel(
      name: 'تسيير واقتصاد',
      iconPath: SVGs.icGestion,
      subjects: [
        Subject(id: 2, name: 'المحاسبة', coefficient: 6),
        Subject(id: 1, name: 'الاقتصاد والمناجمنت', coefficient: 5),
        Subject(id: 3, name: 'الرياضيات', coefficient: 5),
        Subject(id: 5, name: 'اجتماعيات', coefficient: 4),
        Subject(id: 4, name: 'العربية', coefficient: 3),
        Subject(id: 6, name: 'الفرنسية', coefficient: 2),
        Subject(id: 7, name: 'الانجليزية', coefficient: 2),
        Subject(id: 8, name: 'القانون', coefficient: 2),
        Subject(id: 8, name: 'التربية الإسلامية', coefficient: 2),
        Subject(id: 9, name: 'الفلسفة', coefficient: 2),
        Subject(id: 10, name: 'الرياضة', coefficient: 1),
      ],
    )
  ];
});
