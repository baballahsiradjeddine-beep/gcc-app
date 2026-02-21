import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/subscriptions/data/subscription_repository.dart';
import 'package:tayssir/features/subscriptions/presentation/chargily/chargily_state.dart';

class ChargilyController extends StateNotifier<ChargilyState> {
  final Ref ref;
  final SubscriptionRepository subscriptionRepository;

  ChargilyController(this.ref, this.subscriptionRepository)
      : super(const ChargilyState(status: AsyncValue.data(null)));

  Future<void> initChargilyPayment(
      int subscriptionId, String? promotorCode) async {
    state = state.copyWith(status: const AsyncValue.loading());
    try {
      final url = await subscriptionRepository.initChargilyPayment(
        subscriptionId,
        promotorCode,
      );

      state = state.copyWith(
        status: const AsyncValue.data(null),
        url: url,
      );
    } catch (error, stackTrace) {
      state = state.copyWith(
        status: AsyncValue.error(error, stackTrace),
      );
    }
  }

  void setResponse(ChargilyResponse response) {
    state = state.copyWith(response: response);
  }
}

final chargilyControllerProvider =
    StateNotifierProvider<ChargilyController, ChargilyState>((ref) {
  return ChargilyController(ref, ref.watch(subscriptionRepositoryProvider));
});
