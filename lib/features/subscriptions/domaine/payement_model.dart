import 'package:tayssir/features/subscriptions/presentation/state/subscription_controller.dart';

class PayementModel {
  final String icon;
  final String value;
  final String path;
  final PayementMethod payementMethod;
  PayementModel({
    required this.icon,
    required this.value,
    required this.path,
    required this.payementMethod,
  });
}
