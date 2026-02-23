import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';

import '../../../../exceptions/app_exception.dart';
import '../../data/auth_repository.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref.watch(authRepoProvider));
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this._authRepository) : super(const AsyncValue.data(null));

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // await Future.delayed(const Duration(seconds: 2));
      await _authRepository.login(email, password);

      state = const AsyncValue.data(null);
    }
    // cast e to DioException
    on AppException catch (e) {
      state = AsyncValue.error(e, e.stackTrace!);
    }
  }

  Future<void> loginWithGoogle({required String idToken}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signInGoogle(
        idToken: idToken,
      );
      state = const AsyncValue.data(null);
    } on AppException catch (e) {
      AppLogger.logError('Login with Google failed: ${e.message}');
      state = AsyncValue.error(e, e.stackTrace!);
    }
  }
}
