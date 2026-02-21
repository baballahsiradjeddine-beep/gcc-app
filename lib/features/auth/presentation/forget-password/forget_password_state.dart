import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';

import '../register/state/verify_state.dart';

class ForgetPasswordState extends Equatable {
  final String? email;
  final String? code;
  final String? password;
  final PageController pageController;
  final int currentPage;
  final VerifyState verifyState;
  final AsyncValue<void> status;
  const ForgetPasswordState({
    this.email,
    this.code,
    this.password,
    required this.pageController,
    this.currentPage = 0,
    required this.status,
    this.verifyState = const VerifyState(),
  });

  bool get hasError => status.hasError;
  bool get isLoading => status is AsyncLoading;
  int get remainingTime => verifyState.resendRemainingTime;

  factory ForgetPasswordState.empty() {
    return ForgetPasswordState(
      pageController: PageController(),
      currentPage: 0,
      status: const AsyncValue.data(null),
    );
  }

  ForgetPasswordState copyWith({
    String? email,
    String? code,
    String? password,
    PageController? pageController,
    int? currentPage,
    AsyncValue<void>? status,
    VerifyState? verifyState,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      verifyState: verifyState ?? this.verifyState,
    );
  }

  ForgetPasswordState setError(AppException error) {
    return copyWith(
      status: AsyncValue.error(error, error.stackTrace ?? StackTrace.current),
    );
  }

  ForgetPasswordState setLoading() {
    return copyWith(
      status: const AsyncValue.loading(),
    );
  }

  ForgetPasswordState setData() {
    return copyWith(
      status: const AsyncValue.data(null),
    );
  }

  bool get canResend => verifyState.resendRemainingTime == 0;

  ForgetPasswordState decrementRemainingTime() {
    return copyWith(
      verifyState: verifyState.copyWith(
        remainingTime: verifyState.resendRemainingTime - 1,
      ),
    );
  }

  ForgetPasswordState setEmail(String email) {
    return copyWith(
      email: email,
      status: const AsyncValue.data(null),
    );
  }

  ForgetPasswordState setCode(String code) {
    return copyWith(
      code: code,
      status: const AsyncValue.data(null),
    );
  }

  ForgetPasswordState setPassword(String password) {
    return copyWith(
      password: password,
      status: const AsyncValue.data(null),
    );
  }

  @override
  List<Object?> get props => [email, code, password, status, verifyState];
}
