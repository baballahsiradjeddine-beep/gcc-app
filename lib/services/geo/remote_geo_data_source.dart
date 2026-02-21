import 'package:dio/dio.dart';
import 'package:tayssir/providers/dio/dio.dart';

class RemoteGeoDataSource
 {
  final DioClient client;

  RemoteGeoDataSource({required this.client});

  Future<Response> getWilayas() async {
    final response = await client.getStaticContent('/wilayas');
    return response;
  }

  Future<Response> getCommunesByWilaya(int wilayaId) async {
    final response =
        await client.getStaticContent('/wilayas/$wilayaId/communes');
    return response;
  }
}
