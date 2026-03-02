import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/local_auth_data_source.dart';
import 'tokens_model.dart';

final tokenProvider =
    StateNotifierProvider<TokensController, TokensModel>((ref) {
  final localRepository = ref.watch(localAuthDataSourceProvider);
  return TokensController(
    localRepository,
  );
});

class TokensController extends StateNotifier<TokensModel> {
  TokensController(
    this.localRepository,
  ) : super(
          TokensModel.empty(),
        ) {
    initListener();
  }

  final LocalAuthDataSource localRepository;

  void setAccessToken(String token) {
    localRepository.saveToken(token);
  }

  void getTokens() {
    final tokens = localRepository.getTokens();
    state = tokens;
  }

  void setRefreshToken(String token) {
    state = state.copyWith(refreshToken: token);
    localRepository.saveRefreshToken(token);
  }

  void clearToken() {
    state = TokensModel.empty();
    localRepository.clearTokens();
  }

  void initListener() {
    localRepository.listenToTokens((accessToken) {
      state = state.copyWith(accessToken: accessToken);
    }, (refreshToken) {
      if (refreshToken != null) {
        state = state.copyWith(refreshToken: refreshToken);
      }
    });
  }

  void removeListener() {
    localRepository.disposeListeners();
  }

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }
}
