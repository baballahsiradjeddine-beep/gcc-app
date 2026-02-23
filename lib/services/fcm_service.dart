import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:tayssir/environment_config.dart';
import 'package:tayssir/debug/app_logger.dart';

// Top-level function handles background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.logInfo("Handling a background message: ${message.messageId}");
}

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission (especially for iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AppLogger.logInfo(
        'User granted permission: ${settings.authorizationStatus}');

    // Register Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get the FCM token
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        AppLogger.logInfo("FCM Token: $token");
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      AppLogger.logError('Failed to get FCM token: $e');
    }

    // Refresh token listener
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      AppLogger.logInfo("Refreshed FCM Token: $newToken");
      _sendTokenToBackend(newToken);
    });
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final dio = Dio();
      final String? authToken = GetSecureStorage().read('token');
      if (authToken != null) {
        await dio.post(
          '${EnvironmentConfig.apiBaseUrl}/v2/notifications/fcm-token',
          data: {'fcm_token': token},
          options: Options(
            headers: {
              'Authorization': 'Bearer $authToken',
              'Accept': 'application/json',
            },
          ),
        );
        AppLogger.logInfo('Successfully sent FCM token to backend');
      }
    } catch (e) {
      AppLogger.logError('Failed to send FCM token to backend: $e');
    }
  }
}
