import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';

final toolRemoteDataSourceProvider = Provider<ToolRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ToolRemoteDataSource(dioClient: dioClient);
});

class ToolRemoteDataSource {
  final DioClient dioClient;

  ToolRemoteDataSource({
    required this.dioClient,
  });

  Future<Response> getCardsData() async {
    try {
      final response = await dioClient.get(
        EndPoints.cards,
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching cards data: $e');
      rethrow;
    }
  }

  Future<Response> getResumesData() async {
    try {
      final response = await dioClient.get(
        EndPoints.resumes,
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching resumes data: $e');
      rethrow;
    }
  }

  Future<Response> getBacsData() async {
    try {
      final response = await dioClient.get(
        EndPoints.bacs,
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching bacs data: $e');
      rethrow;
    }
  }
}
