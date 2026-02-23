import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/home/data/banners/banner_remote_data_source.dart';
import 'package:tayssir/features/home/presentation/banner_model.dart';

class BannerRepository {
  final BannerRemoteDataSource bannerRemoteDataSource;

  BannerRepository({
    required this.bannerRemoteDataSource,
  });

  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await bannerRemoteDataSource.getBanners();
      final data = response.data['data'];
      final banners =
          data.map<BannerModel>((e) => BannerModel.fromJson(e)).toList();
      return banners;
    } catch (e) {
      return [];
    }
  }
}

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final bannerRemoteDataSource = ref.watch(bannerRemoteDataSourceProvider);
  return BannerRepository(
    bannerRemoteDataSource: bannerRemoteDataSource,
  );
});
