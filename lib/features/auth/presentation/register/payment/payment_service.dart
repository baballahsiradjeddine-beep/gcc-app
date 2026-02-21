

import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  Future<void> pay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

}