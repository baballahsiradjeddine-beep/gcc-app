import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/common/data/configs.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/subscriptions/data/subscription_repository.dart';
import 'package:tayssir/features/subscriptions/domaine/payement_model.dart';
import 'package:tayssir/features/subscriptions/presentation/state/subscription_state.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/providers/user/subscription_model.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

import '../../../../resources/resources.dart';
import '../../../../router/app_router.dart';

enum PayementMethod { baridiMob, card, ccp }

final paymentsMethodesProvider = Provider<List<PayementModel>>((ref) {
  final configs = ref.watch(configsProvider).requireValue;

  return [
    PayementModel(
      icon: SVGs.logo,
      value: 'بطاقة اشتراك',
      path: AppRoutes.subCard.name,
      payementMethod: PayementMethod.card,
    ),
    PayementModel(
      icon: SVGs.ccp,
      value: 'عن طريق ccp',
      path: AppRoutes.subscriptionPaper.name,
      payementMethod: PayementMethod.ccp,
    ),
    if (configs.isChargilyActive)
      PayementModel(
        icon: SVGs.icAlgeriePoste,
        value: 'بريدي موب',
        path: AppRoutes.chargilyInit.name,
        payementMethod: PayementMethod.baridiMob,
      )
  ];
});

final subscriptionControllerProvider = StateNotifierProvider.autoDispose<
    SubscribeWithCardController, SubscriptionState>((ref) {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  return SubscribeWithCardController(subscriptionRepository, ref);
});

class SubscribeWithCardController extends StateNotifier<SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;
  final Ref ref;
  SubscribeWithCardController(this.subscriptionRepository, this.ref)
      : super(const SubscriptionState());
  Future<void> subscribeWithCard(
      String cardNumber, SubscriptionModel subscription) async {
    state = const SubscriptionState(state: AsyncValue.loading());
    try {
      await subscriptionRepository.subscribeWithCard(cardNumber);
      state = const SubscriptionState(state: AsyncValue.data(null));

      ref.read(userNotifierProvider.notifier).updateUserSub(subscription);
      await ref.read(dataProvider.notifier).refreshData();
    } catch (e, st) {
      //TODO
      state = SubscriptionState(
          state: AsyncValue.error(
              AppException(type: AppExceptionType.cardNotValid), st));
    }
  }
}
