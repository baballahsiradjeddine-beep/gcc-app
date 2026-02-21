import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/presentation/register/state/verify_state.dart';

class VerifyEmailState extends Equatable {
  final PageController pageController;
  final int currentPage;
  final VerifyState verifyState;
  final AsyncValue<void> status;
  final bool isCompleted;

  const VerifyEmailState({
    required this.pageController,
    this.currentPage = 0,
    this.status = const AsyncValue.data(null),
    this.verifyState = const VerifyState(),
    this.isCompleted = false,
  });

  int get resendRemainingTime => verifyState.resendRemainingTime;
  bool get canResend => verifyState.resendRemainingTime == 0;
  bool get hasError => status.hasError;
  bool get isLoading => status is AsyncLoading;

  //copyWith method
  VerifyEmailState copyWith({
    PageController? pageController,
    int? currentPage,
    VerifyState? verifyState,
    AsyncValue<void>? value,
    bool? isCompleted,
  }) {
    return VerifyEmailState(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
      verifyState: verifyState ?? this.verifyState,
      status: value ?? status,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  VerifyEmailState setLoading() {
    return copyWith(value: const AsyncValue.loading());
  }

  VerifyEmailState setData() {
    return copyWith(value: const AsyncValue.data(null));
  }

  VerifyEmailState setError(AppException error) {
    return copyWith(
      value: AsyncValue.error(error, error.stackTrace ?? StackTrace.current),
    );
  }
  VerifyEmailState setCompleted() {
    return copyWith(isCompleted: true);
  }

  VerifyEmailState resetTimer() {
    return copyWith(
      verifyState: verifyState.resetTimer(),
    );
  }

  @override
  List<Object?> get props => [
        pageController,
        currentPage,
        verifyState,
        status,
      ];
}
