import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/data/auth_repository.dart';

import 'package:flutter/material.dart';
import 'package:tayssir/features/auth/presentation/verify-email/state/verify_email_state.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

final verifyEmailControllerProvider =
    StateNotifierProvider.autoDispose<VerifyEmailNotifier, VerifyEmailState>(
        (ref) {
  final authRepository = ref.watch(authRepoProvider);
  return VerifyEmailNotifier(authRepository, ref);
});

class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  VerifyEmailNotifier(this.authRepository, this.ref)
      : super(VerifyEmailState(
          pageController: PageController(),
        ));

  final AuthRepository authRepository;
  final Ref ref;
  Timer? _timer;

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
      state = state.copyWith(
        verifyState: state.verifyState.copyWith(
          remainingTime: state.resendRemainingTime - 1,
        ),
      );
    }
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    stop();
    state = state.resetTimer();
  }

  Future<void> sendOtpCode() async {
    try {
      if (state.isLoading) return;
      state = state.setLoading();
      await authRepository.sendVerifyEmailOtpCode();
      state = state.setData();
      _startTimer();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(e, st),
      );
    }
  }

  Future<void> onStart() async {
    await sendOtpCode();
    nextStep();
  }

  Future<void> haveCode() async {
    _startTimer();
    nextStep();
  }

  Future<void> verifyOtp(String pin) async {
    try {
      if (state.isLoading) return;
      state = state.setLoading();
      await authRepository.verifyUser(pin);
      state = state.setData();

      state = state.setCompleted();
      await Future.delayed(const Duration(milliseconds: 500));
      ref.read(userNotifierProvider.notifier).verifyUserEmail();
      stop();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(e, st),
      );
    }
  }

  Future<void> resendOtpCode() async {
    if (!state.canResend) return;
    reset();
    await sendOtpCode();
  }

  void clearError() {
    state = state.setData();
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
    stop();
    state.pageController.dispose();
    super.dispose();
  }
}
