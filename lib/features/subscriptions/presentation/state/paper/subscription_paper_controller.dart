import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/subscriptions/data/subscription_repository.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

class SubscriptionPaperState extends Equatable {
  final AsyncValue<void> state;
  final String subscriptionId;
  final String? promotorCode;

  const SubscriptionPaperState({
    this.state = const AsyncValue.data(null),
    this.subscriptionId = '',
    this.promotorCode,
  });

  @override
  List<Object?> get props => [state, subscriptionId, promotorCode];
}

final subscriptionPaperControllerProvider = StateNotifierProvider.autoDispose<
    SubscribeWithPaperController, SubscriptionPaperState>((ref) {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  return SubscribeWithPaperController(subscriptionRepository, ref);
});

class SubscribeWithPaperController
    extends StateNotifier<SubscriptionPaperState> {
  final SubscriptionRepository subscriptionRepository;
  final Ref ref;

  SubscribeWithPaperController(this.subscriptionRepository, this.ref)
      : super(const SubscriptionPaperState());

  Future<void> subscribeWithPaper({
    required File file,
    required SubscriptionModel subscription,
    String? promotorCode,
  }) async {
    state = const SubscriptionPaperState(state: AsyncValue.loading());
    try {
      await subscriptionRepository.subscribeWithPaper(
        file: file,
        subscriptionId: subscription.id,
        promotorCode: promotorCode,
      );
      // await Future.delayed(const Duration(seconds: 2));

      // ref.read(userNotifierProvider.notifier).updateUserSub(subscription);
      // await ref.read(dataProvider.notifier).refreshData();
      state = const SubscriptionPaperState(state: AsyncValue.data(null));
    } catch (e, st) {
      state = SubscriptionPaperState(
        //todo:change this
        state: AsyncValue.error(
          e as AppException,
          st,
        ),
      );
    }
  }
}
