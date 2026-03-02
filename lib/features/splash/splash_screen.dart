import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../common/core/app_logo.dart';
import '../../resources/resources.dart';
import 'package:tayssir/common/core/app_assets/dynamic_app_asset.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tayssir/providers/app_assets/app_assets_provider.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.isSmallDevice ? 220.h : 250.h;
    final assetsState = ref.watch(appAssetsProvider);

    // Pre-cache assets when they arrive to stop the flicker
    useEffect(() {
      assetsState.whenData((assetsMap) {
        for (var asset in assetsMap.values) {
          if (asset.url.isNotEmpty && !asset.url.toLowerCase().contains('.svg')) {
            precacheImage(CachedNetworkImageProvider(asset.url), context);
          }
        }
      });
      return null;
    }, [assetsState.valueOrNull]);

    return SafeArea(
      top: false,
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset(
            //   Images.tito,
            // ),
            SizedBox(
              height: 1.h,
            ),
            Column(
              children: [
                DynamicAppAsset(
                  assetKey: 'home_hero',
                  fallbackAssetPath: SVGs.titoLogin,
                  type: AppAssetType.svg,
                  height: size,
                ),
                20.verticalSpace,
                const AppLogo(),
              ],
            ),
            // const Spacer(),
            Column(
              children: [
                const TayssirDataLoader(),
                20.verticalSpace,
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class TayssirDataLoader extends StatelessWidget {
  const TayssirDataLoader({
    super.key,
    this.textSize = 20,
    this.iconSize = 50,
  });

  final double textSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'جاري تحميل البيانات',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.textBlack,
              fontSize: textSize.sp,
              fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        LoadingAnimationWidget.progressiveDots(
            size: iconSize, color: AppColors.secondaryColor),
      ],
    );
  }
}
