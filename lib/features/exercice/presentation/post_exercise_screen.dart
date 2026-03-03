import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/constants/strings.dart';
import 'package:tayssir/features/exercice/presentation/state/exercice_controller.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../../resources/resources.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';
import 'widgets/exercice_app_bar.dart';

class MidResultScreen extends HookConsumerWidget {
  const MidResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesState = ref.watch(exercicesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getStatusColor() {
      switch (exercisesState.resultStatus) {
        case ResultStatus.good:
          return const Color(0xFF38DBA3);
        case ResultStatus.bad:
          return const Color(0xFFF87B7C);
        case ResultStatus.average:
          return const Color(0xFFFFB74D);
        default:
          return const Color(0xFF00B4D8);
      }
    }

    String getStatusTitle() {
      switch (exercisesState.resultStatus) {
        case ResultStatus.good:
          return "أداء رائع! ✨";
        case ResultStatus.bad:
          return "لا بأس، حاول مجدداً! 💪";
        case ResultStatus.average:
          return "عمل جيد، استمر! 🚀";
        default:
          return "أحسنت!";
      }
    }

    Widget getMascot() {
      switch (exercisesState.resultStatus) {
        case ResultStatus.good:
          return DynamicAppAsset(
            assetKey: 'tito_good_exercise',
            fallbackAssetPath: SVGs.titoGoodExercise,
            type: AppAssetType.svg,
            height: context.isSmallDevice ? 280.h : 320.h,
          );
        case ResultStatus.bad:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicAppAsset(
                assetKey: 'tito_bad_message',
                fallbackAssetPath: SVGs.titoBadMessage,
                type: AppAssetType.svg,
                height: 80.h,
              ),
              DynamicAppAsset(
                assetKey: 'tito_bad',
                fallbackAssetPath: SVGs.titoBad,
                type: AppAssetType.svg,
                height: 220.h,
              ),
            ],
          );
        case ResultStatus.average:
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicAppAsset(
                assetKey: 'tito_average',
                fallbackAssetPath: SVGs.titoAverage,
                type: AppAssetType.svg,
                height: 220.h,
              ),
              DynamicAppAsset(
                assetKey: 'tito_average_message',
                fallbackAssetPath: SVGs.titoAverageMessage,
                type: AppAssetType.svg,
                height: 80.h,
              ),
            ],
          );
        default:
          return const SizedBox();
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
            // Dynamic Background Glow
            Positioned(
              top: -150.h,
              left: 0,
              right: 0,
              child: Container(
                height: 450.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      getStatusColor().withOpacity(0.15),
                      getStatusColor().withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                child: Column(
                  children: [
                    ExerciceAppBar(
                      exercisesState: exercisesState,
                      onClosePressed: () {
                        ref.read(exercicesProvider.notifier).nextPage();
                        context.pop();
                      },
                    ),
                    
                    const Spacer(flex: 1),
                    
                    Text(
                      getStatusTitle(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: getStatusColor(),
                        fontFamily: 'SomarSans',
                        shadows: [
                          Shadow(
                            color: getStatusColor().withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                    ),
                    
                    20.verticalSpace,
                    
                    Expanded(
                      flex: 4,
                      child: Center(child: getMascot()),
                    ),

                    const Spacer(flex: 1),

                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BigButton(
                            text: AppStrings.continueText,
                            onPressed: () {
                              ref.read(exercicesProvider.notifier).nextPage();
                              context.pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
