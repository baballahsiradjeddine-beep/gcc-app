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

    getMiddle() {
      switch (exercisesState.resultStatus) {
        case ResultStatus.good:
          return DynamicAppAsset(
            assetKey: 'tito_good_exercise',
            fallbackAssetPath: SVGs.titoGoodExercise,
            type: AppAssetType.svg,
            height: context.isSmallDevice ? 310.h : 360.h,
          );
        case ResultStatus.bad:
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DynamicAppAsset(
                assetKey: 'tito_bad_message',
                fallbackAssetPath: SVGs.titoBadMessage,
                type: AppAssetType.svg,
                height: context.isSmallDevice ? 100.h : 120.h,
              ),
              DynamicAppAsset(
                assetKey: 'tito_bad',
                fallbackAssetPath: SVGs.titoBad,
                type: AppAssetType.svg,
                height: context.isSmallDevice ? 220.h : 280.h,
              ),
            ],
          );

        case ResultStatus.average:
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DynamicAppAsset(
                assetKey: 'tito_average',
                fallbackAssetPath: SVGs.titoAverage,
                type: AppAssetType.svg,
                height: context.isSmallDevice ? 220.h : 270.h,
              ),
              DynamicAppAsset(
                assetKey: 'tito_average_message',
                fallbackAssetPath: SVGs.titoAverageMessage,
                type: AppAssetType.svg,
                height: context.isSmallDevice ? 100.h : 120.h,
              ),
            ],
          );
        default:
          return const Text('well done');
      }
    }

    return AppScaffold(
      onPopScope: () {},
      paddingX: 0,
      body: SliverScrollingWidget(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: ExerciceAppBar(
              exercisesState: exercisesState,
              onClosePressed: () {
                ref.read(exercicesProvider.notifier).nextPage();
                context.pop();
              },
            ),
          ),
          5.verticalSpace,
          Expanded(child: getMiddle()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: BigButton(
                text: AppStrings.continueText,
                onPressed: () {
                  ref.read(exercicesProvider.notifier).nextPage();
                  context.pop();
                }),
          ),
        ],
      ),
    );
  }
}
