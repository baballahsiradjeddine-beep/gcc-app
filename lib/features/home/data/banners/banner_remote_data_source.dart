import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';

final bannerRemoteDataSourceProvider = Provider<BannerRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BannerRemoteDataSource(dioClient: dioClient);
});

class BannerRemoteDataSource {
  final DioClient dioClient;

  BannerRemoteDataSource({
    required this.dioClient,
  });

  Future<Response> getBanners() async {
    try {
      final response = await dioClient.get(
        EndPoints.banners,
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching banners: $e');
      rethrow;
    }
  }
}
