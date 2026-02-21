import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tayssir/exceptions/exception_data.dart';
import 'package:tayssir/exceptions/exception_messages.dart';

enum AppExceptionType {
  network,
  server,
  unknown,
  custom,
  wrongCredentials,
  login,
  expectationTime,
  register,
  emailExists,
  phoneExists,
  invalidPin,
  emailNotExists,
  cardNotValid,
  emailNotVerified,
  alreadyPendingRequest,
  invalidPromoCode,
}

class AppException implements Exception {
  final AppExceptionType type;
  final String? customMessage;
  final Object? error;
  final StackTrace? stackTrace;

  AppException({
    required this.type,
    this.customMessage,
    this.error,
    this.stackTrace,
  });

  String get title => _getExceptionData().title;
  String get message => customMessage ?? _getExceptionData().message;

  ExceptionData _getExceptionData() => ExceptionMessages.getData(type);

  static String getErrorMessage(Object? error) {
    if (error is AppException) return error.message;
    return ExceptionMessages.generalMessage;
  }

  factory AppException.fromDioResponse(Response response) {
    final dioException = DioException(
      requestOptions: response.requestOptions,
      response: response,
    );
    return AppException.fromDartException(
        dioException, dioException.stackTrace);
  }

  factory AppException.fromDartException(Object error, StackTrace stackTrace) {
    if (error is AppException) return error;

    if (error is SocketException) {
      return AppException(
          type: AppExceptionType.network, error: error, stackTrace: stackTrace);
    }

    if (error is HttpException) {
      return AppException(
          type: AppExceptionType.server, error: error, stackTrace: stackTrace);
    }

    if (error is DioException) {
      return _handleDioException(error, stackTrace);
    }

    return AppException(
        type: AppExceptionType.unknown, error: error, stackTrace: stackTrace);
  }

  static AppException _handleDioException(
      DioException error, StackTrace stackTrace) {
    final data = error.response?.data;
    String? message = _parseErrorMessage(data);
    //TODO: think of a better way later on
    if (message == 'Invalid reset code') {
      return AppException(
          type: AppExceptionType.invalidPin,
          error: error,
          stackTrace: stackTrace);
    }
    if (message == 'Email not verified') {
      return AppException(
          type: AppExceptionType.emailNotVerified,
          error: error,
          stackTrace: stackTrace);
    }
    if (message != null &&
        message
            .startsWith('You already have a pending manual payment request')) {
      return AppException(
          type: AppExceptionType.alreadyPendingRequest,
          error: error,
          stackTrace: stackTrace);
    }

    if (message != null && message.startsWith('الحقل رمز الترويج غير صالح')) {
      return AppException(
        type: AppExceptionType.invalidPromoCode,
        error: error,
        stackTrace: stackTrace,
      );
    }
    // if (message == 'Invalid page.' && error.response?.statusCode == 404) {
    //   return AppException(type: AppExceptionType.noMorePages, error: error, stackTrace: stackTrace);
    // }

    return AppException(
      type: AppExceptionType.custom,
      error: error,
      stackTrace: stackTrace,
      customMessage: message,
    );
  }

  static String? _parseErrorMessage(dynamic data) {
    if (data is Map) {
      return (data['message'] ?? data['detail'])?.toString();
    }
    return null;
  }

  @override
  String toString() {
    return 'AppException(type: $type, title: $title, message: $message, error: $error)';
  }
}
