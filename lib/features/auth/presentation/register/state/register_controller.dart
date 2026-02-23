import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/data/auth_repository.dart';
import 'package:tayssir/features/auth/presentation/register/state/otp_type.dart';

import '../../../../../providers/user/commune.dart';
import '../../../../../providers/user/wilaya.dart';
import '../../../data/requests/register_request_model.dart';
import 'register_state.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  final authRepository = ref.watch(authRepoProvider);
  return RegisterNotifier(authRepository);
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(
    this.authRepository,
  ) : super(RegisterState.empty());

  final AuthRepository authRepository;
  Timer? _timer;

  void nextPage() {
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    return await authRepository.checkPhoneNumberExists(phoneNumber);
  }

  void setCredentials(String email, String password) async {
    state = state.setLoading();
    try {
      if ((await authRepository.checkEmailExists(email))) {
        state =
            state.setError(AppException(type: AppExceptionType.emailExists));
        return;
      }
    } catch (e, st) {
      state = state.setError(AppException.fromDartException(e, st));
    }
    state = state.setCredentials(
      email,
      password,
    );
    state = state.setData();
    // await sendOtpCode();
    nextPage();
  }

  Future<void> googleSignUp(String idToken, String name, String email) async {
    state = state.setLoading();
    try {
      if ((await authRepository.checkEmailExists(email))) {
        state =
            state.setError(AppException(type: AppExceptionType.emailExists));
        return;
      }
    } catch (e, st) {
      state = state.setError(AppException.fromDartException(e, st));
    }
    state = state.setIdToken(idToken);
    state = state.setUserName(name);

    state = state.setData();
    nextPage();
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
    // _startTimer();
  }

  Future<void> sendOtpCode({OtpType otpType = OtpType.email}) async {
    try {
      if (state.isLoading) return;
      state = state.setLoading();
      if (otpType == OtpType.email) {
        await authRepository.sendEmailOtpCode(state.userData.email);
      } else {
        // await authRepository.sendPhoneOtpCode(state.userData.phoneNumber);
      }
      state = state.setData();
      _startTimer();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(e, st),
      );
    }
  }

  void verifyOtp(String pin, OtpType otpType) async {
    try {
      if (state.isLoading) return;
      state = state.setLoading();
      if (otpType == OtpType.email) {
        await authRepository.verifyEmailOtpCode(state.userData.email, pin);
      } else {
        // await authRepository.verifyPhoneOtpCode(state.userData.phoneNumber, pin);
      }
      state = state.setData();
      stop();
      nextPage();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(e, st),
      );
    }
  }

  void resetOtpOption({OtpType otpType = OtpType.email}) async {
    stop();
    if (otpType == OtpType.email) {
      state = state.copyWith(
        verifyState: state.verifyState.resetTimer(),
        userData: UserData.empty(),
      );
    } else {
      state = state.copyWith(
        verifyState: state.verifyState.resetTimer(),
        userData: state.userData.copyWith(phoneNumber: ''),
      );
    }
    prevPage();
  }

  void resendOtpCode({
    OtpType otpType = OtpType.email,
  }) async {
    if (!state.canResend) return;
    reset();
    await sendOtpCode(otpType: otpType);
  }

  void setUserData(String name, int age, String phoneNumber, Wilaya wilaya,
      Commune commune, int filliere) async {
    state = state.setLoading();
    if ((await isPhoneNumberExists(phoneNumber))) {
      state = state.setError(
        AppException(type: AppExceptionType.phoneExists),
      );
      return;
    }
    state =
        state.setUserData(name, age, phoneNumber, wilaya, commune, filliere);

    state = state.setData();
    // await sendOtpCode(
    //   otpType: OtpType.phone,
    // );

    nextPage();
  }

  Future<void> setKnowOption(int knowOption) async {
    state = state.setKnowOption(knowOption);
    // await fullRegister();
    nextPage();
  }

  Future<void> fullRegister() async {
    if (state.isLoading) return;

    state = state.setLoading();
    try {
      if (state.isGoogleSignUp) {
        await _handleGoogleSignUp();
      } else {
        await _handleEmailSignUp();
      }

      state = state.setData();
      nextPage();
    } catch (e, st) {
      state = state.setError(
        AppException.fromDartException(e, st),
      );
    }
  }

  Future<void> _handleGoogleSignUp() async {
    final model = GoogleSignUpRequest(
      idToken: state.userData.idToken!,
      name: state.userData.fullName,
      phoneNumber: state.userData.phoneNumber,
      age: state.userData.age,
      wilayaId: state.userData.wilaya.number,
      communeId: state.userData.commune.number,
      divisionId: state.userData.filliere,
      referralSourceId: state.userData.knowOption,
    );
    await authRepository.signUpGoogle(model);
  }

  Future<void> _handleEmailSignUp() async {
    final model = CreateAccountRequestModel(
      email: state.userData.email,
      password: state.userData.password,
      fullName: state.userData.fullName,
      phoneNumber: state.userData.phoneNumber,
      age: state.userData.age,
      wilaya: state.userData.wilaya.number,
      commune: state.userData.commune.number,
      filliere: state.userData.filliere,
      knowOption: state.userData.knowOption,
    );
    await authRepository.register(model);
  }

  // payment stuff
  // void setPaymentMethod(
  // PayementMethod paymentMethod,
  // ) {
  // state = state.setPaymentMethod(paymentMethod);
  // nextPage();
  // }
  // //TODO: seperate it into another controller and  pay throught that
  // // pay with card
  // void payWithCard() {
  //   state = state.setLoading();
  //   // state = state.setData();
  //   // nextPage();
  // }

  // // pay with baridi mob
  // void payWithBaridiMob() {
  //   state = state.setLoading();
  //   // state = state.setData();
  //   // nextPage();
  // }

  void prevPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
