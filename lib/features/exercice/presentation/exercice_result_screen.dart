import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/providers/data/models/chapter_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/utils/extensions/context.dart';
import 'package:tayssir/utils/extensions/strings.dart';
import '../../../providers/data/data_provider.dart';
import '../../../resources/resources.dart';
import '../../../router/app_router.dart';
import 'package:tayssir/features/streaks/presentation/streak_notifier.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'widgets/results/result_stats_widget.dart';

class ExerciceResultScreen extends HookConsumerWidget {
  const ExerciceResultScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesState = ref.watch(exercicesProvider);
    final dataState = ref.watch(dataProvider);

    final isComplete = exercisesState.bestProgress == 100;
    final user = ref.watch(userNotifierProvider).valueOrNull;
    final firstChapterId = exercisesState.exercises.isNotEmpty 
        ? exercisesState.exercises.first.chapterId 
        : -1;
    final visib = dataState.getChapterVisibility(firstChapterId);

    String getTitle() {
      switch (visib) {
        case ChapterVisibility.fresh:
          return 'عدد النقاط';
        case ChapterVisibility.current:
        case ChapterVisibility.done:
          if (isComplete) {
            return 'عدد الإجابات الصحيحة';
          } else {
            return 'النقاط الجديدة';
          }
        default:
          return 'عدد النقاط';
      }
    }

    String getValue() {
      switch (visib) {
        case ChapterVisibility.fresh:
          return exercisesState.points.toString();

        case ChapterVisibility.current:
        case ChapterVisibility.done:
          if (isComplete) {
            return '${exercisesState.numberofCorrectAnswers}/${exercisesState.exercises.length}';
          } else {
            return exercisesState.resultPoints.toString();
          }

        default:
          return exercisesState.points.toString();
      }
    }

    // const bonusPoints = 10;
    // dataState
    // .getChapterBonusPoints(exercisesState.exercises.first.chapterId);
    return AppScaffold(
        onPopScope: () {},
        body: SliverScrollingWidget(
          children: [
            Text(exercisesState.accuracy.resultText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                )),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                30.horizontalSpace,
                DynamicAppAsset(
                  assetKey: exercisesState.accuracy.resultAssetKey(),
                  fallbackAssetPath: exercisesState.accuracy.resultIcon(),
                  type: AppAssetType.svg,
                  height: context.isSmallDevice ? 180.h : 260.h,
                ),
              ],
            ),
            if (exercisesState.isReviewMode)
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                       Text(
                        "ذكاء تيتو في تطور! 🧠",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF00B4D8),
                          fontFamily: 'SomarSans',
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        "لقد أتممت مراجعة ذكية لـ ${exercisesState.exercises.length} سؤالاً كنت تعاني منهم سابقاً. لقد زادت نسبة إتقانك لهذه المواضيع بشكل ملحوظ!",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              ResultStatsWidget(
                  // value:
                  // '${bonusPoints > 0 ? "(اكمال الفصل)$bonusPoints + " : ""}${exercisesState.points}'
                  // .trim(),
                  value: getValue(),
                  title: getTitle(),
                  icon: isComplete ? SVGs.icResultCheck : SVGs.icGem),
              15.verticalSpace,
              Row(
                children: [
                  Expanded(
                      child: ResultStatsWidget(
                          value: exercisesState.accuracy.toPercentage(),
                          title: 'الدقة',
                          icon: SVGs.icPrecision,
                          startColor: const Color(0xffF87B7C),
                          endColor: const Color(0xffF85556))),
                  8.horizontalSpace,
                  Expanded(
                      child: ResultStatsWidget(
                          value: exercisesState.elapsedTime.toTime,
                          title: 'التوقيت',
                          icon: SVGs.icTime,
                          startColor: const Color(0xff3ADBA3),
                          endColor: const Color(0xff00AC70))),
                ],
              ),
            ],
            const Spacer(),
            10.verticalSpace,
            BigButton(
              text: AppStrings.continueText,
              onPressed: () async {
                final unitId = dataState
                    .getChapterById(firstChapterId)
                    .unitId;

                final streakState = ref.read(streakNotifierProvider).value;
                final bool didStreakIncrease =
                    streakState?.streakIncreasedToday ?? false;

                await Future.delayed(const Duration(milliseconds: 100));

                if (context.mounted) {
                  if (exercisesState.isReviewMode) {
                    context.goNamed(AppRoutes.home.name);
                    return;
                  }
                  final chapterId = exercisesState.exercises.first.chapterId;
                  
                  // Special handling for the guest tutorial tour
                  if (chapterId == -999) {
                    // Set tour step to 99 to trigger the registration sheet on Home
                    await ref.read(onboardingProvider.notifier).setTourStep(99);
                    if (context.mounted) {
                      context.goNamed(AppRoutes.home.name);
                    }
                    return;
                  }

                  if (user?.email != null) {
                    await AppLogger.sendLog(
                      email: user!.email,
                      content:
                          'Finished exercise: ${dataState.getChapterById(firstChapterId).title} Accuracy: ${exercisesState.accuracy.toPercentage()}',
                      type: LogType.chapters,
                    );
                  }

                  if (context.mounted) {
                    final bool hasStudiedToday = streakState?.history
                            .any((day) => day.isToday && day.studied) ??
                        false;

                    if (context.mounted) {
                      if ((didStreakIncrease || hasStudiedToday) && streakState != null) {
                        context.pushReplacementNamed(
                          AppRoutes.streak.name,
                          extra: {
                            'streak': streakState,
                            'unitId': unitId,
                          },
                        );
                      } else {
                        context.pushReplacementNamed(
                          AppRoutes.chapters.name,
                          pathParameters: {
                            'unitId': unitId.toString(),
                          },
                        );
                      }
                    }
                  }
                }
              },
            )
          ],
        ));
  }
}
