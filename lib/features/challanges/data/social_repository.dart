import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/dio/dio.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SocialRepository(dioClient);
});

class SocialRepository {
  final DioClient _dioClient;

  SocialRepository(this._dioClient);

  Future<List<dynamic>> searchUsers(String query) async {
    final response = await _dioClient
        .get('/v2/social/search', queryParameters: {'q': query});
    return response.data['data'];
  }

  Future<void> sendFriendRequest(int receiverId) async {
    await _dioClient
        .post('/v2/social/requests/send', data: {'receiver_id': receiverId});
  }

  Future<void> acceptFriendRequest(int requestId) async {
    await _dioClient
        .post('/v2/social/requests/accept', data: {'request_id': requestId});
  }

  Future<void> rejectFriendRequest(int requestId) async {
    await _dioClient
        .post('/v2/social/requests/reject', data: {'request_id': requestId});
  }

  Future<List<dynamic>> getFriends() async {
    final response = await _dioClient.get('/v2/social/friends');
    return response.data['data'];
  }

  Future<List<dynamic>> getPendingRequests() async {
    final response = await _dioClient.get('/v2/social/requests/pending');
    return response.data['data'];
  }

  Future<void> sendChallengeInvite({
    required int receiverId,
    required int unitId,
    required String courseTitle,
    required String invitationCode,
  }) async {
    await _dioClient.post('/v2/social/challenge/invite', data: {
      'receiver_id': receiverId,
      'unit_id': unitId,
      'course_title': courseTitle,
      'invitation_code': invitationCode,
    });
  }
}
