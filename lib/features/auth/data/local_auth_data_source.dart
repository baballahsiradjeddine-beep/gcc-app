// local auth data source

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:tayssir/environment_config.dart';

import '../../../providers/token/tokens_model.dart';

final secureStorageProvider = Provider<GetSecureStorage>((ref) {
  return GetSecureStorage(password: EnvironmentConfig.boxPassword);
});

final localAuthDataSourceProvider = Provider<LocalAuthDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return LocalAuthDataSource(secureStorage);
});

class LocalAuthDataSource {
  final GetSecureStorage _secureStorage;

  LocalAuthDataSource(this._secureStorage);

  Function? disposeAccessTokenListener;
  Function? disposeRefreshTokenListener;
  void saveToken(String token) {
    _secureStorage.write(BoxKeys.token.name, token);
  }

  void saveTokens(TokensModel tokens) {
    _secureStorage.write(BoxKeys.token.name, tokens.accessToken);
    _secureStorage.write(BoxKeys.refreshToken.name, tokens.refreshToken);
  }

  TokensModel getTokens() {
    final accessToken = _secureStorage.read(BoxKeys.token.name);
    final refreshToken = _secureStorage.read(BoxKeys.refreshToken.name);
    return TokensModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  String? getAccessToken() {
    return _secureStorage.read(BoxKeys.token.name);
  }

  void saveRefreshToken(String token) {
    _secureStorage.write(BoxKeys.refreshToken.name, token);
  }

  String? getRefreshToken() {
    return _secureStorage.read(BoxKeys.refreshToken.name);
  }

  void listenAccessToken(Function(dynamic) listener) {
    disposeAccessTokenListener =
        _secureStorage.listenKey(BoxKeys.token.name, listener);
  }

  void listenRefreshTokenKey(Function(dynamic) listener) {
    disposeRefreshTokenListener =
        _secureStorage.listenKey(BoxKeys.refreshToken.name, listener);
  }

  disposeListeners() {
    disposeAccessTokenListener?.call();
    disposeRefreshTokenListener?.call();
  }

  listenToTokens(Function(dynamic) accessTokenCallback,
      Function(dynamic) refreshTokenCallback) {
    listenAccessToken(accessTokenCallback);
    listenRefreshTokenKey(refreshTokenCallback);
  }

  void clearTokens() {
    clearAccessToken();
    clearRefreshToken();
  }

  void clearAccessToken() {
    _secureStorage.remove(BoxKeys.token.name);
  }

  void clearRefreshToken() {
    _secureStorage.remove(BoxKeys.refreshToken.name);
  }
}

enum BoxKeys { token, refreshToken, user, theme, isOnBoarding }
