import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/tools/grade_calc/speciality_model.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

import '../../../common/tito_advice_widget.dart';
import '../../../constants/strings.dart';
import 'state/grade_controller.dart';
import 'widgets/speciality_drop_down.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'subject_widget.dart';

class GradeCalculatorScreen extends HookConsumerWidget {
  const GradeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialities = ref.watch(specialityProvider);
    final currentSpeciality = useState<SpecialityModel>(specialities.first);
    final state = ref.watch(gradeControllerProvider(currentSpeciality.value));
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    final wasPassing = useRef<bool>(state.isPassing);

    useEffect(() {
      if (isSoundOn && state.isPassing && !wasPassing.value) {
        SoundService.playPoints();
      }
      wasPassing.value = state.isPassing;
      return null;
    }, [state.isPassing]);
    return AppScaffold(
        paddingB: 0,
        body: SliverScrollingWidget(
          header: const TitoAdviceWidget(
            text: AppStrings.calculateGrades,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: SpecialityDropDown(
                    items: specialities,
                    // icon: IconData(cu),

                    onChanged: (speciality) {
                      if (isSoundOn) SoundService.playClickPremium();
                      currentSpeciality.value = speciality!;
                    },
                    selectedItem: currentSpeciality.value,
                    hintText: "اختر التخصص",
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            ...state.subjects.map((subject) => SubjectWidget(
                  subjectName: state.getSubjectName(subject.subjectId),
                  subjectGrade: subject.grade,
                  subjectCoef: state.getCofficientOfSubject(subject.subjectId),
                  onGradeChange: (grade) {
                    if (isSoundOn) SoundService.playClickPremium();
                    ref
                        .read(gradeControllerProvider(currentSpeciality.value)
                            .notifier)
                        .updateGrade(subject.subjectId, grade);
                  },
                )),

            // result
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            " معدل البكالوريا : ",
                          ),
                          Text(
                            state.isPassing ? "(ناجح)" : "(راسب)",
                            style: TextStyle(
                              color: state.average >= 10
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      )),
                ),
                10.horizontalSpace,
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: state.isPassing ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(state.average.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ],
            ),

            20.verticalSpace,
          ],
        ));
  }
}
