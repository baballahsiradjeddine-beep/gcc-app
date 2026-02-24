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
    final user = ref.watch(userNotifierProvider).requireValue!;
    final visib = dataState
        .getChapterVisibility(exercisesState.exercises.first.chapterId);

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
                SvgPicture.asset(
                  exercisesState.accuracy.resultIcon(),
                  height: context.isSmallDevice ? 180.h : 260.h,
                ),
              ],
            ),
            30.verticalSpace,
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
            const Spacer(),
            10.verticalSpace,
            BigButton(
              text: AppStrings.continueText,
              onPressed: () async {
                final unitId = dataState
                    .getChapterById(exercisesState.exercises.first.chapterId)
                    .unitId;

                final streakState = ref.read(streakNotifierProvider).value;
                final bool didStreakIncrease =
                    streakState?.streakIncreasedToday ?? false;

                await Future.delayed(const Duration(milliseconds: 100));

                if (context.mounted) {
                  await AppLogger.sendLog(
                    email: user.email,
                    content:
                        'Finished exercise: ${dataState.getChapterById(exercisesState.exercises.first.chapterId).title} Accuracy: ${exercisesState.accuracy.toPercentage()}',
                    type: LogType.chapters,
                  );

                  if (context.mounted) {
                    if (didStreakIncrease) {
                      context.pushReplacementNamed(
                        AppRoutes.streak.name,
                        extra: {
                          'streak': streakState!,
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
              },
            )
          ],
        ));
  }
}
