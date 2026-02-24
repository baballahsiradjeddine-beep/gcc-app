import 'dart:async';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:tayssir/constants/app_consts.dart';
import 'package:tayssir/debug/device_helper.dart';

enum LogType { auth, home, chapters, tools, subscriptions }

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );

  static final Dio _dio = Dio();
  static const Map<LogType, String> _webhookUrls = {
    LogType.auth:
        'https://discord.com/api/webhooks/1358739488305709217/5PWFZ9ctnKYTcFgxqW23UtlREFra4a1G7S6r8cvJAELExU2qUguFa0R28FZb6Ipg9hkB',
    LogType.home:
        'https://discord.com/api/webhooks/1358747660995133441/lQEbI6YZ0CRlgQSrTbS_wf626UwChhI_C-rwhllof_XspjJtVchU5W2PN8ksMidjqLGi',
    LogType.chapters:
        'https://discord.com/api/webhooks/1358747256919949408/3t9OD8mlebChr_bPZiUpO_YiWqTqSrFTCNeR8DdY4iMHVLc_fPv87pidmu2_Dsq8aT8s',
    LogType.tools:
        'https://discord.com/api/webhooks/1358747637846769904/DLJ_Yug4eu63Fla0gaFItbffNj-6sisChXWqJ8bpHDk5qIbM61K8bkB54aQgxFGe9rg0',
    LogType.subscriptions:
        'https://discord.com/api/webhooks/1358747686542639245/kGtIYcCUARwy9H8wXFx57vbc8gFbz2aD3bA9nrvOB4Y5qEHLNqMaTJp2nGfLo4v9AtYL',
  };

  static String _getWebhookUrl(LogType type) {
    return _webhookUrls[type] ?? _webhookUrls[LogType.auth]!;
  }

  static void logDebug(dynamic message) {
    _logger.d(message);
  }

  static void logError(dynamic message) {
    _logger.e(message);
  }

  static void logWarning(dynamic message) {
    _logger.w(message);
  }

  static void logInfo(dynamic message) {
    _logger.i(message);
  }

  static Future<void> sendLog({
    required String email,
    required String content,
    LogType type = LogType.auth,
    bool forceTestAccount = false,
  }) async {
    // Discord logging disabled as requested
    return;
  }
}
