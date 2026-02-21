import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/presentation/register/state/verify_state.dart';

class ChangeEmailState extends Equatable {
  final String? email;
  final String? code;
  final String? password;
  final PageController pageController;
  final int currentPage;
  final VerifyState verifyState;
  final AsyncValue<void> status;
  const ChangeEmailState({
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

  factory ChangeEmailState.empty() {
    return ChangeEmailState(
      pageController: PageController(),
      currentPage: 0,
      status: const AsyncValue.data(null),
    );
  }

  ChangeEmailState copyWith({
    String? email,
    String? code,
    String? password,
    PageController? pageController,
    int? currentPage,
    AsyncValue<void>? status,
    VerifyState? verifyState,
  }) {
    return ChangeEmailState(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      verifyState: verifyState ?? this.verifyState,
    );
  }

  ChangeEmailState setError(AppException error) {
    return copyWith(
      status: AsyncValue.error(error, error.stackTrace ?? StackTrace.current),
    );
  }

  ChangeEmailState setLoading() {
    return copyWith(
      status: const AsyncValue.loading(),
    );
  }

  ChangeEmailState setData() {
    return copyWith(
      status: const AsyncValue.data(null),
    );
  }

  bool get canResend => verifyState.resendRemainingTime == 0;

  ChangeEmailState decrementRemainingTime() {
    return copyWith(
      verifyState: verifyState.copyWith(
        remainingTime: verifyState.resendRemainingTime - 1,
      ),
    );
  }

  ChangeEmailState setEmail(String email) {
    return copyWith(
      email: email,
      status: const AsyncValue.data(null),
    );
  }

  ChangeEmailState setCode(String code) {
    return copyWith(
      code: code,
      status: const AsyncValue.data(null),
    );
  }

  ChangeEmailState setPassword(String password) {
    return copyWith(
      password: password,
      status: const AsyncValue.data(null),
    );
  }

  @override
  List<Object?> get props => [email, code, password, status, verifyState];
}
