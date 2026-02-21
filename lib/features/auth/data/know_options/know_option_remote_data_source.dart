import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';

final knowOptionRemoteDataSourceProvider =
    Provider<KnowOptionRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return KnowOptionRemoteDataSourceImpl(dio: dioClient);
});

abstract class KnowOptionRemoteDataSource {
  Future<Response> getKnowOptions();
}

class KnowOptionRemoteDataSourceImpl implements KnowOptionRemoteDataSource {
  final DioClient dio;

  KnowOptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<Response> getKnowOptions() async {
    try {
      final response = await dio.getStaticContent(
        EndPoints.knowOptions,
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching know options data: $e');
      rethrow;
    }
  }
}
