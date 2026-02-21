import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionState extends Equatable {
  final AsyncValue<void> state;
  final String cardNumber;
  const SubscriptionState(
      {this.state = const AsyncValue.data(null), this.cardNumber = ''});

  @override
  List<Object?> get props => [state, cardNumber];
}
