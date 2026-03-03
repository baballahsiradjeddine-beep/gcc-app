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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

    return AppScaffold(
        onPopScope: () {},
        paddingX: 0,
        paddingY: 0,
        body: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          ),
          child: Stack(
            children: [
              // Ambient Glow
              Positioned(
                top: -100.h,
                left: 0,
                right: 0,
                child: Container(
                  height: 350.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.07),
                        AppColors.primaryColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      24.verticalSpace,
                      Text(
                        exercisesState.accuracy.resultText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SomarSans',
                          shadows: [
                            Shadow(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      DynamicAppAsset(
                        assetKey: exercisesState.accuracy.resultAssetKey(),
                        fallbackAssetPath: exercisesState.accuracy.resultIcon(),
                        type: AppAssetType.svg,
                        height: context.isSmallDevice ? 200.h : 270.h,
                      ),
                      const Spacer(flex: 1),
                      if (exercisesState.isReviewMode)
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B4D8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                                color: const Color(0xFF00B4D8).withOpacity(0.25),
                                width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "ذكاء تيتو في تطور! 🧠",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF00B4D8),
                                  fontFamily: 'SomarSans',
                                ),
                              ),
                              12.verticalSpace,
                              Text(
                                "لقد أتممت مراجعة ذكية لـ ${exercisesState.exercises.length} سؤالاً كنت تعاني منهم سابقاً. لقد زادت نسبة إتقانك لهذه المواضيع بشكل ملحوظ!",
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: isDark
                                      ? Colors.white60
                                      : const Color(0xFF64748B),
                                  fontFamily: 'SomarSans',
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        ResultStatsWidget(
                            value: getValue(),
                            title: getTitle(),
                            icon:
                                isComplete ? SVGs.icResultCheck : SVGs.icGem),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                                child: ResultStatsWidget(
                                    value:
                                        exercisesState.accuracy.toPercentage(),
                                    title: 'الدقة',
                                    icon: SVGs.icPrecision,
                                    startColor: const Color(0xffF87B7C),
                                    endColor: const Color(0xffF85556))),
                            12.horizontalSpace,
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
                      const Spacer(flex: 1),
                      20.verticalSpace,
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

                            // Special handling for the guest tutorial tour
                            if (firstChapterId == -999) {
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
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
