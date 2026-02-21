import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/services/geo/remote_geo_data_source.dart';

class GeoRepository {
  GeoRepository({
    required this.remoteDataSource,
    //  required this.localDataSource
  });

  final RemoteGeoDataSource remoteDataSource;
  // final LocalGeoDataSource localDataSource;

  Future<List<Wilaya>> getWilayas() async {
    final response = await remoteDataSource.getWilayas();
    final wilayas =
        response.data.map<Wilaya>((wilaya) => Wilaya.fromMap(wilaya)).toList();

    return wilayas;
  }

  Future<List<Commune>> getCommunesByWilaya(int wilayaId) async {
    final response = await remoteDataSource.getCommunesByWilaya(wilayaId);
    final communes = response.data
        .map<Commune>((commune) => Commune.fromMap(commune))
        .toList();

    return communes;
  }
}
