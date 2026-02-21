import 'package:dio/dio.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/providers/dio/dio.dart';

class DivisionDataSource {
  final DioClient dioClient;

  DivisionDataSource({required this.dioClient});

  Future<Response> getDivisions() async {
    final response = await dioClient.getStaticContent(EndPoints.divisions);
    return response;
  }
}
