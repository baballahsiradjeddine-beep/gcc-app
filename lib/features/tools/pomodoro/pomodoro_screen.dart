import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodor_status_x.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_controller.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_state.dart';
import 'package:tayssir/features/tools/pomodoro/state/pomodoro_status.dart';
import 'package:tayssir/features/tools/pomodoro/status_info_card.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tayssir/services/actions/dialog_service.dart';
import 'package:tayssir/utils/extensions/context.dart';
import '../../../common/tito_bubble_talk_widget.dart';
import '../../../utils/enums/triangle_side.dart';

class PomodoroScreen extends HookConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PomodoroState>(pomodoroControllerProvider, (prev, next) {
      if (next.status == PomodoroStatus.stopped &&
          prev?.status != PomodoroStatus.stopped) {
        DialogService.showPomodoroDoneDialog(context, () {
          ref.read(pomodoroControllerProvider.notifier).reset();
        });
      }
    });
    final state = ref.watch(pomodoroControllerProvider);
    String getTime() {
      final minutes = state.remainingTime ~/ 60;
      final seconds = state.remainingTime % 60;
      if (minutes < 10) {
        if (seconds < 10) {
          return "0$minutes:0$seconds";
        }
        return "0$minutes:$seconds";
      }
      if (seconds < 10) {
        return "$minutes:0$seconds";
      }
      return "$minutes:$seconds";
    }

    return AppScaffold(
        paddingB: 0,
        topSafeArea: true,
        body: SliverScrollingWidget(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusInfoCard(
                  title: 'الجلسة',
                  value: '${state.completedSessions + 1}',
                  color: AppColors.primaryColor.withOpacity(0.8),
                ),
                5.horizontalSpace,
                StatusInfoCard(
                  title: state.currentPhaseName,
                  titleFontSize: state.currentPhaseName == 'عمل' ? 20 : 13,
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
                5.horizontalSpace,
                StatusInfoCard(
                  title: 'الدورة',
                  value: '${state.currentCycle}/${state.totalCycles}',
                  color: AppColors.primaryColor.withOpacity(0.6),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
              ),
              child: TitoBubbleTalkWidget(
                text: state.status.adviceText,
                triangleSide: TriangleSide.bottom,
              ),
            ),
            context.isSmallDevice ? 10.verticalSpace : 50.verticalSpace,

            //TODO: can use EXPANDED FOR tablet and desktop
            Flexible(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: CircularPercentIndicator(
                  animation: true,
                  // restartAnimation: true,
                  animationDuration: 1000,
                  animateFromLastPercent: true,
                  reverse: true,
                  widgetIndicator:
                      // red circle
                      Center(
                    child: Container(
                        height: context.isSmallDevice ? 30.h : 30.h,
                        width: context.isSmallDevice ? 30.h : 30.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        // child is white container
                        child: Center(
                          child: Container(
                            height: context.isSmallDevice ? 15.h : 15.h,
                            width: context.isSmallDevice ? 15.h : 15.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),

                  radius: context.isSmallDevice ? 140.0 : 170.0,
                  lineWidth: 8.0,
                  percent: state.progress,
                  center: SvgPicture.asset(
                    state.status.statusSvg,
                    height: context.isSmallDevice ? 170.h : 220.h,
                  ),
                  progressColor: AppColors.greyColor,
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),
            context.isSmallDevice ? 10.verticalSpace : 40.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
              ),
              child: Text(
                getTime(),
                style: TextStyle(
                  fontSize: 40.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.isRunning)
                        FloatingActionButton(
                          heroTag: 'pause',
                          onPressed: () => ref
                              .read(pomodoroControllerProvider.notifier)
                              .pause(),
                          backgroundColor: AppColors.primaryColor,
                          mini: true,
                          child: const Icon(Icons.pause, color: Colors.white),
                        )
                      else
                        FloatingActionButton(
                          heroTag: 'play',
                          onPressed: () => ref
                              .read(pomodoroControllerProvider.notifier)
                              .start(),
                          backgroundColor: AppColors.primaryColor,
                          mini: true,
                          child:
                              const Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      20.horizontalSpace,
                      FloatingActionButton(
                        heroTag: 'skipNext',
                        onPressed: () => ref
                            .read(pomodoroControllerProvider.notifier)
                            .skipToNextPhase(),
                        backgroundColor: AppColors.primaryColor,
                        mini: true,
                        child: const Icon(Icons.skip_next, color: Colors.white),
                      ),
                      20.horizontalSpace,
                      FloatingActionButton(
                        heroTag: 'reset',
                        //disable if state.canReset == false else null,
                        onPressed: state.canReset
                            ? () {
                                ref
                                    .read(pomodoroControllerProvider.notifier)
                                    .reset();
                              }
                            : null,
                        disabledElevation: 0,
                        foregroundColor: Colors.white,
                        backgroundColor: state.canReset
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                        mini: true,
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.verticalSpace,
          ],
        ));
  }
}
