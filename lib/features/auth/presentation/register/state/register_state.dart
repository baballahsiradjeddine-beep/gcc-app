import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/auth/presentation/register/state/verify_state.dart';

import '../../../../../exceptions/app_exception.dart';
import '../../../../../providers/user/commune.dart';
import '../../../../../providers/user/wilaya.dart';

class RegisterState extends Equatable {
  final int currentPage;
  final PageController pageController;
  final UserData userData;
  final VerifyState verifyState;
  final AsyncValue<void> value;
  final bool isGoogleSignUp;
  const RegisterState({
    required this.currentPage,
    required this.pageController,
    required this.userData,
    this.verifyState = const VerifyState(),
    this.value = const AsyncValue.data(null),
    this.isGoogleSignUp = false,
  });

  factory RegisterState.empty() {
    return RegisterState(
      currentPage: 0,
      pageController: PageController(),
      userData: UserData.empty(),
    );
  }
  RegisterState copyWith({
    int? currentPage,
    PageController? pageController,
    VerifyState? verifyState,
    UserData? userData,
    AsyncValue<void>? value,
    bool? isGoogleSignUp,
  }) {
    return RegisterState(
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
      verifyState: verifyState ?? this.verifyState,
      userData: userData ?? this.userData,
      value: value ?? this.value,
      isGoogleSignUp: isGoogleSignUp ?? this.isGoogleSignUp,
    );
  }

  bool get canResend => verifyState.resendRemainingTime == 0;

  RegisterState setLoading() {
    return copyWith(
      value: const AsyncValue.loading(),
    );
  }

  RegisterState setGoogleSignUp(bool isGoogleSignUp) {
    return copyWith(
      isGoogleSignUp: isGoogleSignUp,
    );
  }

  RegisterState setIdToken(String idToken) {
    return copyWith(
        userData: userData.copyWith(idToken: idToken), isGoogleSignUp: true);
  }

  RegisterState setData() {
    return copyWith(
      value: const AsyncValue.data(null),
    );
  }

  RegisterState setUserName(String name) {
    return copyWith(userData: userData.copyWith(fullName: name));
  }

  RegisterState decrementRemainingTime() {
    return copyWith(
      verifyState: verifyState.copyWith(
        remainingTime: verifyState.resendRemainingTime - 1,
      ),
    );
  }

  RegisterState setCredentials(
    String email,
    String password,
  ) {
    return copyWith(
      userData: userData.copyWith(
        email: email,
        password: password,
      ),
    );
  }

  RegisterState setError(AppException error) {
    return copyWith(
      value: AsyncValue.error(error, error.stackTrace ?? StackTrace.current),
    );
  }

  bool get isLoading => value is AsyncLoading;

  RegisterState setKnowOption(
    int knowOption,
  ) {
    return copyWith(
      userData: userData.copyWith(
        knowOption: knowOption,
      ),
    );
  }

  RegisterState setUserData(
    String fullName,
    int age,
    String phoneNumber,
    Wilaya wilaya,
    Commune commune,
    int filliere,
  ) {
    return copyWith(
      userData: userData.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        wilaya: wilaya,
        commune: commune,
        filliere: filliere,
        age: age,
      ),
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        pageController,
        userData,
        verifyState,
        value,
        isGoogleSignUp,
      ];
}

class UserData extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final int age;
  final Wilaya wilaya;
  final Commune commune;
  final int filliere;
  final int knowOption;
  final String? idToken;

  const UserData({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.wilaya,
    required this.commune,
    required this.filliere,
    required this.knowOption,
    this.idToken,
  });

  // empty
  factory UserData.empty() {
    return UserData(
        email: '',
        password: '',
        fullName: '',
        phoneNumber: '',
        age: 0,
        wilaya: Wilaya.empty(),
        commune: Commune.empty(),
        filliere: 1,
        knowOption: 0);
  }

  UserData copyWith({
    String? email,
    String? password,
    String? fullName,
    String? phoneNumber,
    int? age,
    Wilaya? wilaya,
    Commune? commune,
    int? filliere,
    int? knowOption,
    String? idToken,
  }) {
    return UserData(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      filliere: filliere ?? this.filliere,
      knowOption: knowOption ?? this.knowOption,
      idToken: idToken ?? this.idToken,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        fullName,
        phoneNumber,
        age,
        wilaya,
        commune,
        filliere,
        knowOption,
        idToken,
      ];
}
