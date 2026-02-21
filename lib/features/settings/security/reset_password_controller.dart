import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';

import '../../auth/data/auth_repository.dart';

final resetPasswordController = StateNotifierProvider.autoDispose<
    ResetPasswordController, AsyncValue<void>>(
  (ref) {
    final authRepository = ref.watch(authRepoProvider);
    return ResetPasswordController(authRepository);
  },
);

class ResetPasswordController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;
  ResetPasswordController(this.authRepository)
      : super(const AsyncValue.data(null));

  void resetPassword(
    String oldPassword,
    String newPassword,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await authRepository.resetPassword(
        oldPassword,
        newPassword,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e as AppException, st);
    }
  }
}
