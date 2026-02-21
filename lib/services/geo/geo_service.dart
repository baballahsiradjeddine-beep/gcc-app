import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/services/geo/geo_repository.dart';
import 'package:tayssir/services/geo/remote_geo_data_source.dart';

import '../../providers/dio/dio.dart';
import '../../providers/user/user_model.dart';

final geoServiceProvider = Provider((ref) {
  const UserModel? user = null;
  return GeoService(geoRepository: ref.watch(geoRepoProvider), user: user);
});

final wilayasProvider = FutureProvider<List<Wilaya>>((ref) async {
  final geoService = ref.watch(geoServiceProvider);
  return await geoService.getWilayas();
});

// removed auto dispose
final communesProvider =
    FutureProvider.family<List<Commune>, int>((ref, wilayaId) async {
  final geoService = ref.watch(geoServiceProvider);
  return await geoService.getCommunesByWilaya(wilayaId);
});

// simple cached system [ maybe later on store them in local storage]
class GeoService {
  final GeoRepository geoRepository;
  final UserModel? user;

  GeoService({required this.geoRepository, required this.user}) {
    // AppLogger.logInfo('rayan init');
    // init();
  }
  List<Commune> userCommunes = [];
  Wilaya? wilaya;

  // init() async {
  //   if (user != null) {
  //     AppLogger.logInfo(' init user not null');
  //     if (wilaya != null) {
  //       AppLogger.logInfo(' init wilaya not null');
  //       if (user!.wilaya != null && user!.wilaya!.number != wilaya!.number) {
  //         AppLogger.logInfo(' init wilaya not null and not equal');
  //         wilaya = user!.wilaya;
  //         userCommunes =
  //             await geoRepository.getCommunesByWilaya(wilaya!.number);
  //       }
  //     } else {
  //       if (user!.wilaya != null) {
  //         AppLogger.logInfo(' init wilaya null');
  //         wilaya = user!.wilaya;
  //         userCommunes =
  //             await geoRepository.getCommunesByWilaya(wilaya!.number);
  //       }
  //     }
  //   }
  // }

  Future<List<Wilaya>> getWilayas() async {
    return await geoRepository.getWilayas();
  }

  Future<List<Commune>> getCommunesByWilaya(int wilayaId) async {
    // if (user != null &&
    //     user!.wilaya != null &&
    //     wilayaId == user!.wilaya!.number) {
    //   return userCommunes;
    // }
    return await geoRepository.getCommunesByWilaya(wilayaId);
  }
}

final remoteGeoDataSourceProvider = Provider<RemoteGeoDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RemoteGeoDataSource(client: dioClient);
});

final geoRepoProvider = Provider<GeoRepository>((ref) {
  final remoteDataSource = ref.watch(remoteGeoDataSourceProvider);
  // final localDataSource = ref.watch(localDataSourceProvider);
  return GeoRepository(
    remoteDataSource: remoteDataSource,
    // localDataSource: localDataSource,
  );
});
