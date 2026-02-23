import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';

class LeaderboardRemoteDataSource {
  final DioClient dioClient;

  LeaderboardRemoteDataSource({
    required this.dioClient,
  });

  Future<Response> getLeaderboard(int page) async {
    try {
      final response = await dioClient.get(
        EndPoints.leaderboard,
        queryParameters: {
          'page': page.toString(),
          'per_page': '100',
        },
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching leaderboard: $e');
      rethrow;
    }
  }
}

final leaderboardRemoteDataSourceProvider =
    Provider<LeaderboardRemoteDataSource>(
  (ref) {
    final dioClient = ref.watch(dioClientProvider);
    return LeaderboardRemoteDataSource(
      dioClient: dioClient,
    );
  },
);
