import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NotificationsRemoteDataSource(dio: dioClient);
});

class NotificationsRemoteDataSource {
  final DioClient dio;

  NotificationsRemoteDataSource({required this.dio});

  Future<Response> getNotifications({int? page}) async {
    try {
      final response = await dio.get(
        EndPoints.notifications,
        queryParameters: {
          if (page != null) 'page': page,
        },
      );
      return response;
    } catch (e) {
      AppLogger.logError('Error fetching notifications data: $e');
      rethrow;
    }
  }

  Future<Response> markAsRead(String notificationId) async {
    try {
      final response = await dio.post(EndPoints.markNotificationAsRead, data: {
        'ids': [notificationId],
      });
      return response;
    } catch (e) {
      AppLogger.logError('Error marking notification as read: $e');
      rethrow;
    }
  }
}
