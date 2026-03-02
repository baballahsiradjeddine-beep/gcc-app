import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/data/auth_repository.dart';
import 'package:tayssir/features/settings/security/change_email/change_email_state.dart';

final changeEmailControllerProvider = StateNotifierProvider.autoDispose<
    ForgetPasswordController, ChangeEmailState>((ref) {
  return ForgetPasswordController(
    authRepository: ref.watch(authRepoProvider),
  );
});

class ForgetPasswordController extends StateNotifier<ChangeEmailState> {
  ForgetPasswordController({
    required this.authRepository,
  }) : super(ChangeEmailState.empty());

  final AuthRepository authRepository;
  Timer? _timer;

  void onEmailEntered(String email) async {
    if (state.isLoading) return;
    state = state.setLoading();
    final exists = await checkEmailExists(email);
    if (exists) {
      state = state.setError(
        AppException(
          type: AppExceptionType.emailExists,
        ),
      );
      return;
    }
    await sendOtpCode(email);
    nextStep();
  }

  Future<bool> checkEmailExists(String email) async {
    final result = await authRepository.checkEmailExists(email);
    return result;
  }

  Future<void> sendOtpCode(String email) async {
    try {
      await authRepository.sendChangeEmailOtpCode(email);
      state = state.setEmail(email);
      _startTimer();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(
          e,
          st,
        ),
      );
    }
  }

  Future<void> verifyOtpCode(String code) async {
    if (state.isLoading) return;
    state = state.setLoading();
    try {
      await authRepository.verifyChangeEmailOtpCode(state.email!, code);
      state = state.setCode(code);
      AppLogger.logInfo('code: $code');
      // stop();
      nextStep();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(
          e,
          st,
        ),
      );
    }
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      tick();
    });
  }

  void tick() {
    if (state.canResend) {
      stop();
    } else {
      state = state.decrementRemainingTime();
    }
  }

  void clearError() {
    state = state.setData();
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    stop();
    state = state.copyWith(verifyState: state.verifyState.resetTimer());
  }

  void resendOtpCode() async {
    if (!state.canResend) return;
    reset();
    await sendOtpCode(state.email!);
  }

  void changeEmail() async {
    stop();
    state = state.copyWith(
      verifyState: state.verifyState.resetTimer(),
      email: null,
    );
    prevStep();
  }

  void nextStep() {
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void prevStep() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  @override
  void dispose() {
    state.pageController.dispose();

    super.dispose();
  }
}
