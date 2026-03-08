import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
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
    return const GradeCalculatorBody();
  }
}

class GradeCalculatorBody extends HookConsumerWidget {
  const GradeCalculatorBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialities = ref.watch(specialityProvider);
    final currentSpeciality = useState<SpecialityModel>(specialities.first);
    final state = ref.watch(gradeControllerProvider(currentSpeciality.value));
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    final wasPassing = useRef<bool>(state.isPassing);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    useEffect(() {
      if (isSoundOn && state.isPassing && !wasPassing.value) {
        SoundService.playPoints();
      }
      wasPassing.value = state.isPassing;
      return null;
    }, [state.isPassing]);

    return AppScaffold(
      topSafeArea: true,
      includeBackButton: true,
      paddingB: 0,
      paddingX: 0,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.scaffoldColor,
      appBar: Text(
        "حاسبة المعدل",
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'SomarSans',
          color: isDark ? Colors.white : AppColors.textBlack,
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Advice Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const TitoAdviceWidget(
                    text: AppStrings.calculateGrades,
                  ),
                ),
              ),

              // Speciality Dropdown
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
                  child: SpecialityDropDown(
                    items: specialities,
                    onChanged: (speciality) {
                      if (isSoundOn) SoundService.playClickPremium();
                      if (speciality != null) currentSpeciality.value = speciality;
                    },
                    selectedItem: currentSpeciality.value,
                    hintText: "اختر التخصص",
                  ),
                ),
              ),

              // Subjects List
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final subject = state.subjects[index];
                      return SubjectWidget(
                        subjectName: state.getSubjectName(subject.subjectId),
                        subjectGrade: subject.grade,
                        subjectCoef: state.getCofficientOfSubject(subject.subjectId),
                        onGradeChange: (grade) {
                          if (isSoundOn) SoundService.playClickPremium();
                          ref.read(gradeControllerProvider(currentSpeciality.value).notifier)
                             .updateGrade(subject.subjectId, grade);
                        },
                      ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.1, end: 0);
                    },
                    childCount: state.subjects.length,
                  ),
                ),
              ),

              // Bottom Spacer for Results Card - increased to clear bottom nav more reliably
              SliverToBoxAdapter(child: 180.verticalSpace),
            ],
          ),

          // Total Result Card (Floating at bottom) - Raised to clear bottom nav
          Positioned(
            bottom: 85.h, // Raised higher to clear the bottom navigation bar
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "معدل البكالوريا المتوقع :",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? Colors.white70 : AppColors.greyColor,
                            fontFamily: 'SomarSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        4.verticalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: (state.isPassing ? Colors.green : Colors.red).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            state.isPassing ? "ناجح بإذن الله 😍" : "راسب (شد حيلك) ✍️",
                            style: TextStyle(
                              color: state.isPassing ? Colors.green : Colors.red,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: state.isPassing 
                          ? [const Color(0xFF10B981), const Color(0xFF059669)]
                          : [const Color(0xFFEF4444), const Color(0xFFB91C1C)],
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: (state.isPassing ? Colors.green : Colors.red).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.average.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        Text(
                          "من 20",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ).animate(target: state.average).shimmer(duration: 1.seconds),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
