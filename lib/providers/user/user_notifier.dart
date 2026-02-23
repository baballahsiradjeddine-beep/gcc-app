import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/token/token_controller.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/services/user/update_user_request.dart';
import 'package:tayssir/utils/extensions/response.dart';

import '../../services/user/user_service.dart';
import 'user_model.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier(ref.watch(userServiceProvider), ref);
});

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  UserNotifier(this.userService, this.ref)
      : super(AsyncValue.data(UserModel.empty())) {
    init();
  }

  void init() {
    ref.listen(
      tokenProvider,
      (prevTokens, nextTokens) async {
        if (nextTokens.refreshToken != null &&
            nextTokens.refreshToken!.isNotEmpty &&
            nextTokens.accessToken != null &&
            nextTokens.accessToken!.isNotEmpty) {
          // final hasInternet = await ref.watch(internetStatusProvider.future);
          // if (hasInternet) {
          getUser();
          // }
        } else {
          clearUser();
        }
      },
      // fireImmediately: true
    );
  }

  final UserService userService;

  Future<void> getUser() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      final user = await userService.getUser();
      await AppLogger.sendLog(
        email: user.email,
        content: 'User made a transition to authenticated state',
      );
      state = AsyncValue.data(user);
    } on DioException catch (e) {
      //TODO: Enhacnce error handling here by checking the error type and defining Exceptions
      if (e.response!.isUnauthorized) {
        clearUser();
      }
    }
  }

  set userSubscription(List<SubscriptionModel> userSubscription) {
    state = AsyncValue.data(
        state.requireValue!.copyWith(subscriptions: userSubscription));
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }

  Future<void> updateUser(UpdateUserRequest userReq) async {
    // if (state.isLoading) return;

    // state = const AsyncValue.loading();

    try {
      final prevUser = state.requireValue!;
      userReq = userReq.checkFields(state.requireValue!);

      if (userReq.needSave) {
        final newUser = await userService.updateUser(userReq);
        state = AsyncValue.data(newUser);
        if (userReq.shouldUpadateData) {
          ref.read(dataProvider.notifier).refreshData();
        }
      } else {
        state = AsyncValue.data(prevUser);
      }
    } on DioException catch (e, st) {
      if (e.response?.isUnauthorized == true) {
        clearUser();
      } else {
        state = AsyncValue.error(e, st);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void updateUserPoints(int points) {
    state = AsyncValue.data(state.requireValue!.addPoints(points));
  }

  void verifyUserEmail() {
    state = AsyncValue.data(state.requireValue!.verifyEmail());
  }

  void updateUserSub(SubscriptionModel newSub) {
    state = AsyncValue.data(state.requireValue!.addSubscription(newSub));
  }

  void setUserNewNotificationsStatus(bool hasNew) {
    state = AsyncValue.data(
        state.requireValue!.copyWith(hasNewNotifications: hasNew));
  }
}
