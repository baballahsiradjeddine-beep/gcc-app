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
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.isSmallDevice ? 220.h : 250.h;
    final assetsState = ref.watch(appAssetsProvider);
    final dataState = ref.watch(dataProvider);
    final materials = dataState.contentData.modules;
    final user = ref.watch(userNotifierProvider).valueOrNull;

    // 1. Pre-cache dynamic App Assets (Heros, Characters, Arena)
    useEffect(() {
      assetsState.whenData((assetsMap) {
        for (final asset in assetsMap.values) {
          if (asset.url.isNotEmpty) {
            // CRITICAL: We MUST match the URL format in DynamicAppAsset (url?version)
            // If the version is missing, DynamicAppAsset uses an empty string query or similar.
            final fullUrl = '${asset.url}?${asset.version}';
            
            if (!fullUrl.toLowerCase().contains('.svg')) {
              // Pre-cache regular images (PNG, JPG)
              precacheImage(CachedNetworkImageProvider(fullUrl), context);
            }
            // Note: SVG precaching is complex in the background without the exact loader class,
            // but the PNG case with ?version is the most common cause of flickers.
          }
        }
      });
      return null;
    }, [assetsState.valueOrNull]);

    // 2. Pre-cache subject/material images early!
    useEffect(() {
      if (materials.isNotEmpty) {
        for (final m in materials) {
          final imageUrls = [m.imageList, m.imageGrid];
          for (final rawUrl in imageUrls) {
            if (rawUrl.isNotEmpty) {
               final fullUrl = rawUrl.startsWith('http') 
                  ? rawUrl 
                  : 'https://gcc.tayssir-bac.com/storage/${rawUrl.replaceAll(RegExp(r'^/'), '')}';
               precacheImage(CachedNetworkImageProvider(fullUrl), context);
            }
          }
        }
      }
      return null;
    }, [materials.length]);

    // 3. Pre-cache user profile assets to avoid flickering in the Header
    useEffect(() {
      if (user != null) {
        if (user.completeProfilePic.isNotEmpty) {
          precacheImage(CachedNetworkImageProvider(user.completeProfilePic), context);
        }
        final badgeUrl = user.badge?.completeIconUrl;
        if (badgeUrl != null && badgeUrl.isNotEmpty) {
          precacheImage(CachedNetworkImageProvider(badgeUrl), context);
        }
      }
      return null;
    }, [user?.id]);

    return SafeArea(
      top: false,
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Column(
              children: [
                // Display the logo or a hero image in the middle of splash
                // NEW: Only reveal the hero once we have the metadata to avoid the 'flicker'
                // between the fallback dolphin and the server's hero.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: assetsState.maybeWhen(
                    data: (_) => DynamicAppAsset(
                      key: const ValueKey('splash_hero_ready'),
                      assetKey: 'home_hero',
                      fallbackAssetPath: SVGs.titoLogin,
                      type: AppAssetType.svg,
                      height: size,
                    ),
                    orElse: () => SizedBox(
                      key: const ValueKey('splash_hero_loading'),
                      height: size,
                      // We can put a subtle shimmer or just leave it empty 
                      // to make the appearance of the hero feel like a 'reveal'
                    ),
                  ),
                ),
                20.verticalSpace,
                const AppLogo(),
              ],
            ),
            Column(
              children: [
                // The loader text and indicator
                const TayssirDataLoader(),
                30.verticalSpace,
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
