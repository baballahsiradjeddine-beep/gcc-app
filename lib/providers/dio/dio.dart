import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tayssir/environment_config.dart';

import 'auth_interceptor.dart';

final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = EnvironmentConfig.apiBaseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5000);
  dio.options.receiveTimeout = const Duration(seconds: 3000);
  dio.options.headers = {
    'contentType': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
  if (false)
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        enabled: kDebugMode,
        filter: (options, args) {
          if (options.path.endsWith('content')) {
            return false;
          }
          return !args.isResponse || !args.hasUint8ListData;
        },
        error: true,
        compact: true));
  return dio;
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = EnvironmentConfig.apiBaseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5000);
  dio.options.receiveTimeout = const Duration(seconds: 3000);
  dio.options.headers = {
    'contentType': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      filter: (options, args) {
        if (options.path.endsWith('content')) {
          return false;
        }
        return !args.isResponse || !args.hasUint8ListData;
      },
      responseHeader: false,
      error: true,
      compact: true));
  return dio;
});

final dummyDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = EnvironmentConfig.staticContentBaseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5000);
  dio.options.receiveTimeout = const Duration(seconds: 3000);
  dio.options.headers = {
    'contentType': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true));
  return dio;
});
final dioClientProvider = Provider<DioClient>((ref) {
  ref.onDispose(() {});
  final dio = ref.watch(dioProvider);
  dio.interceptors.add(AuthInterceptor(ref));

  return DioClient(dio, ref.watch(dummyDioProvider));
});

class DioClient {
  final Dio dio;
  final Dio staticDio;
  DioClient(this.dio, this.staticDio);

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> post(String path,
      {Map<String, dynamic>? queryParameters,
      required data,
      contentType = Headers.jsonContentType}) async {
    try {
      final response = await dio.post(path,
          queryParameters: queryParameters,
          data: data,
          options: Options(contentType: contentType));
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> put(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      final response =
          await dio.put(path, queryParameters: queryParameters, data: data);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> patch(String path,
      {Map<String, dynamic>? queryParameters,
      required Map<String, dynamic> data}) async {
    try {
      final response =
          await dio.patch(path, queryParameters: queryParameters, data: data);
      return response;
    } on DioException {
      rethrow;
    }
  }

  // get static content
  Future<Response> getStaticContent(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await staticDio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> postFormData(
    String path, {
    Map<String, dynamic>? queryParameters,
    required FormData formData,
    String contentType = 'multipart/form-data',
  }) async {
    try {
      final response = await dio.post(
        path,
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          contentType: contentType,
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Future<Response> dummyGet(String path,
  //     {Map<String, dynamic>? queryParameters}) async {
  //   try {
  //     // final newDio = dio..options.baseUrl = EnvironmentConfig.devApi;
  //     final response = await staticDio.get(path, queryParameters: queryParameters);
  //     return response;
  //   } on DioException {
  //     rethrow;
  //   }
  // }

  // Future<Response> dummyPost(String path,
  //     {Map<String, dynamic>? queryParameters,
  //     required data,
  //     contentType = Headers.jsonContentType}) async {
  //   try {
  //     final response = await staticDio.post(path,
  //         queryParameters: queryParameters,
  //         data: data,
  //         options: Options(contentType: contentType));
  //     return response;
  //   } on DioException {
  //     rethrow;
  //   }
  // }
}
