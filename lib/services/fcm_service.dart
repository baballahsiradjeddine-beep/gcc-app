import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:tayssir/environment_config.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tayssir/services/sounds/sound_manager.dart';
import '../firebase_options.dart';

// Top-level function handles background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
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

    // Foreground Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AppLogger.logInfo(
          "Message received in foreground: ${message.notification?.title}");
      if (message.notification != null) {
        
        // Play notification sound if enabled
        try {
          final prefs = await SharedPreferences.getInstance();
          final settingsJson = prefs.getString('settings');
          bool isSoundEnabled = true; // Default
          if (settingsJson != null) {
            final settingsMap = jsonDecode(settingsJson);
            isSoundEnabled = settingsMap['isSoundEnabled'] ?? true;
          }
          if (isSoundEnabled) {
            SoundService.playNotification();
          }
        } catch (e) {
          AppLogger.logError('Error checking sound settings for notification: $e');
        }

        final isChallenge = message.data['type'] == 'challenge_invite';
        String? imageUrl = message.notification?.android?.imageUrl ??
            message.notification?.apple?.imageUrl ??
            message.data['image'];

        toastification.showCustom(
          autoCloseDuration: const Duration(seconds: 10),
          alignment: Alignment.topCenter,
          builder: (BuildContext context, ToastificationItem holder) {
            return GestureDetector(
              onTap: () {
                toastification.dismiss(holder);
                _handleMessageNavigation(message);
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: isChallenge
                      ? Colors.pink[50]!.withOpacity(0.95)
                      : const Color(0xFFE5E5E5).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: isChallenge
                          ? Colors.pink
                          : Colors.black.withOpacity(0.04),
                      width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 44,
                          height: 44,
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/svg/good_tito.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.notification!.title ?? 'إشعار جديد',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message.notification!.body ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isChallenge) ...[
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            toastification.dismiss(holder);
                            _handleMessageNavigation(message);
                          },
                          child: const Text('قبول'),
                        ),
                      ] else if (imageUrl != null) ...[
                        const SizedBox(width: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(imageUrl,
                              width: 38, height: 38, fit: BoxFit.cover),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });

    // Handle initial message (when app is opened from terminated state via notification)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.logInfo(
          "App opened from initial message: ${initialMessage.messageId}");
      _handleMessageNavigation(initialMessage);
    }

    // Get the FCM token
    syncToken();

    // Refresh token listener
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      AppLogger.logInfo("Refreshed FCM Token: $newToken");
      _sendTokenToBackend(newToken);
    });
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    if (message.data['type'] == 'challenge_invite') {
      final code = message.data['invitation_code'];
      final unitId = int.tryParse(message.data['unit_id'] ?? '0') ?? 0;
      final courseTitle = message.data['course_title'] ?? '';

      if (code != null && rootNavigatorKey.currentContext != null) {
        rootNavigatorKey.currentContext!.pushNamed(
          AppRoutes.challengeMatchmaking.name,
          extra: {
            'unitId': unitId,
            'courseTitle': courseTitle,
            'initialSearchMode': 'join_private',
            'invitationCode': code,
          },
        );
      }
    }
  }

  static Future<void> syncToken() async {
    print("FCM: syncToken() called");
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("FCM: Token obtained: $token");
        AppLogger.logInfo("FCM Token obtained: $token");
        await _sendTokenToBackend(token);
      } else {
        print("FCM: Token is null");
        AppLogger.logWarning("FCM Token is null");
      }
    } catch (e) {
      print("FCM: Error getting token: $e");
      AppLogger.logError('Failed to get FCM token: $e');
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    print("FCM: _sendTokenToBackend() called");
    try {
      final dio = Dio();
      final storage = GetSecureStorage(password: EnvironmentConfig.boxPassword);
      final String? authToken = storage.read('token');

      if (authToken != null) {
        print("FCM: Sending token to backend...");
        AppLogger.logInfo('Sending FCM token to backend...');
        final response = await dio.post(
          '${EnvironmentConfig.apiBaseUrl}/v2/notifications/fcm-token',
          data: {'fcm_token': token},
          options: Options(
            headers: {
              'Authorization': 'Bearer $authToken',
              'Accept': 'application/json',
            },
          ),
        );
        if (response.statusCode == 200) {
          print("FCM: Successfully sent to backend");
          AppLogger.logInfo('Successfully sent FCM token to backend');
        } else {
          print("FCM: Backend error: ${response.statusCode}");
          AppLogger.logWarning(
              'Failed to send FCM token to backend: ${response.statusCode} ${response.data}');
        }
      } else {
        print("FCM: No authToken found in storage");
        AppLogger.logWarning(
            'FCM token NOT sent: User is not authenticated (authToken is null)');
      }
    } catch (e) {
      print("FCM: Network error sending to backend: $e");
      AppLogger.logError('Failed to send FCM token to backend: $e');
    }
  }
}
