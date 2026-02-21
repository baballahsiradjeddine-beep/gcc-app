import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/router/routes_service.dart';

class ImagePrecacheService {
  const ImagePrecacheService._();

  /// Caches a list of image URLs
  /// Returns the count of successfully cached images
  static Future<int> cacheImages(List<String> imageUrls) async {
    if (imageUrls.isEmpty) {
      return 0;
    }
    // return 0;

    AppLogger.logInfo('🖼️ Precaching ${imageUrls.length} images...');

    int successCount = 0;

    for (final url in imageUrls) {
      try {
        await precacheImage(
          CachedNetworkImageProvider(url),
          rootScaffoldMessengerKey.currentContext!,
        );
        successCount++;
      } catch (e) {
        AppLogger.logError('❌ Failed to cache image $url: $e');
      }
    }

    AppLogger.logInfo(
        '✅ Successfully cached $successCount/${imageUrls.length} images');

    return successCount;
  }

  /// Clears all cached images
  static Future<void> clearCache() async {
    try {
      await CachedNetworkImage.evictFromCache('');
      AppLogger.logInfo('🧹 Image cache cleared');
    } catch (e) {
      AppLogger.logError('❌ Failed to clear image cache: $e');
    }
  }
}
