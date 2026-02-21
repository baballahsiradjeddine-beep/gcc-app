import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/services/user/update_user_request.dart';

import '../../providers/user/user_model.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  // final user = ref.watch(userNotifierProvider).requireValue;
  // final geoService = ref.watch(geoServiceProvider);
  final userNotifier = ref.watch(userNotifierProvider.notifier);

  return ProfileController(
    // user: user,
    userNotifier: userNotifier,
  );
});

// can be optimized  for better performance and better code quality . put the user lcoally in here
class ProfileController extends StateNotifier<ProfileState> {
  final UserNotifier userNotifier;

  ProfileController({
    // user,
    required this.userNotifier,
  }) : super(ProfileState.initial());

  Future<void> updateUser(UpdateUserRequest userReq) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await userNotifier.updateUser(userReq);
      state = state.copyWith(isLoading: false);
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWithIsCompleted();
      // state = state.copyWith(user: userNotifier.state.requireValue);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

class ProfileState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isCompleted;

  const ProfileState({
    required this.user,
    required this.isLoading,
    required this.error,
    this.isCompleted = false,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: null,
      isLoading: false,
      error: null,
    );
  }

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  ProfileState copyWithIsCompleted() {
    return ProfileState(
      user: user,
      isLoading: isLoading,
      error: error,
      isCompleted: true,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, error, isCompleted];
}
