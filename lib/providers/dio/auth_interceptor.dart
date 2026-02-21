import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/providers/token/token_controller.dart';
import 'package:tayssir/providers/token/tokens_model.dart';

import '../../utils/extensions/response.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;
  AuthInterceptor(this.ref) {
    init();
  }

  void init() {
    ref.listen<TokensModel>(tokenProvider, (previous, next) {
      accessToken = next.accessToken;
      refreshToken = next.refreshToken;
    }, fireImmediately: true);
  }

  String? accessToken;
  String? refreshToken;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (accessToken != null) {
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response == null) {
      super.onError(err, handler);
      return;
    }
    AppLogger.logInfo('Fares : error happend ');
    if (err.response!.isUnauthorized) {
      try {
        AppLogger.logInfo('Fares : Refreshing token');
        final newToken = await _refreshToken();
        if (newToken != null) {
          AppLogger.logDebug('Fares : Token refreshed');
          return _retryRequest(err.requestOptions, handler, newToken);
        }
        AppLogger.logError(
            'Fares :rror while refreshing tokens: removing them');
        ref.read(tokenProvider.notifier).clearToken();
        super.onError(err, handler);
      } on DioException catch (e) {
        AppLogger.logError('Fares : error code ${e.response!.statusCode}');
        if (e.response == null) {
          super.onError(err, handler);
          return;
        }
        if (e.response!.isUnauthorized) {
          ref.read(tokenProvider.notifier).clearToken();
          return handler.reject(err);
        }
        AppLogger.logError('Error while refreshing tokens: removing them  $e');
      } catch (e) {
        AppLogger.logError('Error while refreshing tokens: removing them  $e');
      }
    }

    super.onError(err, handler);
    // else if (err.response!.isForbidden) {}
  }

  void _retryRequest(RequestOptions requestOptions,
      ErrorInterceptorHandler handler, String newToken) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    options.headers!['Authorization'] = 'Bearer $newToken';

    final dio = ref.read(authDioProvider);
    dio
        .request<dynamic>(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options,
        )
        .then(
          (response) => handler.resolve(response),
          onError: (error) => handler.reject(error),
        );
  }

  Future<String?> _refreshToken() async {
    final authDio = ref.read(authDioProvider);
    authDio.options.headers['Authorization'] = 'Bearer $refreshToken';
    final response = await authDio.post('/v1/auth/refresh-token');
    response.throwIfNotSuccessful();
    if (!response.isSuccessful) {
      return null;
    }
    final newToken = response.customData['token'] as String;
    ref.read(tokenProvider.notifier).setAccessToken(newToken);
    return newToken;
  }
}
