import 'package:equatable/equatable.dart';

class VerifyState extends Equatable {
  final int resendRemainingTime;

  const VerifyState({
    this.resendRemainingTime = 30,
  });

  factory VerifyState.empty() {
    return const VerifyState(
      resendRemainingTime: 30,
    );
  }

  VerifyState copyWith({
    int? remainingTime,
  }) {
    return VerifyState(
      resendRemainingTime: remainingTime ?? resendRemainingTime,
    );
  }

  VerifyState resetTimer() {
    return VerifyState.empty();
  }

  // VerifyState tick() {
  //   return copyWith(
  //     remainingTime: remainingTime - 1,
  //   );
  // }

  @override
  List<Object?> get props => [
        resendRemainingTime,
      ];
}
