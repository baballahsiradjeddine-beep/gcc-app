import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/dio/dio.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ChallengeRepository(dioClient);
});

class ChallengeRepository {
  final DioClient _dioClient;

  ChallengeRepository(this._dioClient);

  Future<Map<String, dynamic>> getQuestions(int unitId) async {
    try {
      final response = await _dioClient.get('/v2/challenges/questions/$unitId');
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      if (e is DioException) {
        print('--- GET QUESTIONS ERROR ---');
        print(e.response?.data);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitResult({
    required int unitId,
    required bool isWinner,
    required int pointsGained,
  }) async {
    try {
      print(
          'Sending POST to /v2/challenges/result with unit_id: $unitId, points: $pointsGained');
      final response = await _dioClient.post('/v2/challenges/result', data: {
        'unit_id': unitId,
        'is_winner': isWinner,
        'points_gained': pointsGained,
      });
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      if (e is DioException) {
        print('--- DIO ERROR 500 DETAILS ---');
        print(e.response?.data);
        print('-----------------------------');
      }
      rethrow;
    }
  }
}
