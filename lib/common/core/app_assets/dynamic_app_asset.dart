import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tayssir/providers/app_assets/app_assets_provider.dart';

enum AppAssetType { svg, image }

class DynamicAppAsset extends ConsumerWidget {
  /// The unique key for this asset (matches the backend key)
  final String assetKey;

  /// The local fallback asset path (e.g. 'assets/svg/subscribe.svg' or 'assets/png/hero.png')
  final String fallbackAssetPath;

  /// Whether the fallback is an SVG or normal Image
  final AppAssetType type;

  /// Optional parameters for SVG or Image
  final double? width;
  final double? height;
  final BoxFit fit;

  const DynamicAppAsset({
    super.key,
    required this.assetKey,
    required this.fallbackAssetPath,
    this.type = AppAssetType.svg, // Default is SVG because it's most common in your app
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsState = ref.watch(appAssetsProvider);

    return assetsState.maybeWhen(
      data: (assetsMap) {
        final serverAsset = assetsMap[assetKey];
        
        if (serverAsset != null && serverAsset.url.isNotEmpty) {
          final imageUrl = '${serverAsset.url}?${serverAsset.version}';
          final isSvg = imageUrl.toLowerCase().contains('.svg');
          
          if (isSvg) {
            return SvgPicture.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (BuildContext context) => _buildFallback(),
            );
          } else {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => _buildFallback(),
              errorWidget: (context, url, error) {
                print('>>> DynamicAppAsset ERROR [$assetKey]: $error');
                return _buildFallback();
              },
            );
          }
        }

        // Otherwise (or if URL is empty), use the local fallback
        return _buildFallback();
      },
      // If loading or error, use local fallback so user never sees a broken image
      orElse: () => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    if (type == AppAssetType.svg) {
      return SvgPicture.asset(
        fallbackAssetPath,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.asset(
        fallbackAssetPath,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}
