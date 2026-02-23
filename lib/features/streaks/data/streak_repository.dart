import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/features/streaks/data/streak_model.dart';
import 'package:tayssir/debug/app_logger.dart';

class StreakRepository {
  final DioClient dioClient;

  StreakRepository({required this.dioClient});

  Future<StreakModel?> getStreakInfo() async {
    try {
      final response = await dioClient.get(EndPoints.streaks);
      if (response.statusCode == 200 && response.data['data'] != null) {
        return StreakModel.fromJson(response.data['data']);
      }
    } catch (e) {
      AppLogger.logError('Failed to fetch streak info: $e');
    }
    return null;
  }

  Future<StreakModel?> pingStreak() async {
    try {
      final response = await dioClient.post(EndPoints.pingStreak, data: {});
      if (response.statusCode == 200 && response.data['data'] != null) {
        return StreakModel.fromJson(response.data['data']);
      }
    } catch (e) {
      AppLogger.logError('Failed to ping streak: $e');
    }
    return null;
  }
}

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return StreakRepository(dioClient: dioClient);
});
