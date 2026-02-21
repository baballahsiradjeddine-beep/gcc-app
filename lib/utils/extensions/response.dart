import 'package:dio/dio.dart';

extension ResponseX on Response {
  mapTo<T>(T Function(Map<String, dynamic> json) fromJson) {
    return fromJson(data);
  }

  T mapToList<T>(T Function(List<dynamic> json) fromJson) {
    return fromJson(data);
  }

  bool get isSuccessful =>
      (statusCode! >= 200 && statusCode! < 300) && data['success'] == true;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  Map<String, dynamic> get customData {
    if (data is Map<String, dynamic>) {
      return data['data'];
    }
    return {};
  }

  Map<String, dynamic> get getUser {
    if (data is Map<String, dynamic>) {
      return data['data']['user'];
    }
    return {};
  }

  void throwIfNotSuccessful() {
    if (statusCode! < 200 || statusCode! >= 300 && data['success'] == false) {
      throw DioException(
        response: this,
        error: errorMessage,
        requestOptions: requestOptions,
      );
    }
  }

  String? get errorMessage {
    if (data is Map<String, dynamic> && data['success'] == false) {
      return data['data']['error'];
    }
    return null;
  }

  String get token {
    if (data is Map<String, dynamic>) {
      return data['token'] as String;
    }
    return '';
  }
}
