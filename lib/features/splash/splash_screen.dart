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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tayssir/providers/app_assets/app_assets_provider.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _precacheData();
  }

  @override
  void didUpdateWidget(SplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _precacheData();
  }

  void _precacheData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // 1. Pre-cache dynamic App Assets
      final assetsState = ref.read(appAssetsProvider);
      assetsState.whenData((assetsMap) {
        if (!mounted) return;
        for (final asset in assetsMap.values) {
          if (asset.url.isNotEmpty) {
            final fullUrl = '${asset.url}?${asset.version}';
            if (!fullUrl.toLowerCase().contains('.svg')) {
              precacheImage(CachedNetworkImageProvider(fullUrl), context);
            }
          }
        }
      });

      // 2. Pre-cache subject/material images
      final materials = ref.read(dataProvider).contentData.modules;
      if (materials.isNotEmpty && mounted) {
        for (final m in materials) {
          final imageUrls = [m.imageList, m.imageGrid];
          for (final rawUrl in imageUrls) {
            if (rawUrl.isNotEmpty && mounted) {
               final fullUrl = rawUrl.startsWith('http') 
                  ? rawUrl 
                  : 'https://gcc.tayssir-bac.com/storage/${rawUrl.replaceAll(RegExp(r'^/'), '')}';
               precacheImage(CachedNetworkImageProvider(fullUrl), context);
            }
          }
        }
      }

      // 3. Pre-cache user profile assets
      final user = ref.read(userNotifierProvider).valueOrNull;
      if (user != null && mounted) {
        if (user.completeProfilePic.isNotEmpty) {
          precacheImage(CachedNetworkImageProvider(user.completeProfilePic), context);
        }
        final badgeUrl = user.badge?.completeIconUrl;
        if (badgeUrl != null && badgeUrl.isNotEmpty && mounted) {
          precacheImage(CachedNetworkImageProvider(badgeUrl), context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = context.isSmallDevice ? 220.h : 250.h;
    final assetsState = ref.watch(appAssetsProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 1.h),
              Column(
                children: [
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
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  const AppLogo(),
                ],
              ),
              Column(
                children: [
                  const TayssirDataLoader(),
                  30.verticalSpace,
                ],
              ),
            ],
          ),
        ),
      ),
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
