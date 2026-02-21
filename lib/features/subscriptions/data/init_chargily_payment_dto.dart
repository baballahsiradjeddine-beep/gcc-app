class InitChargilyPaymentDto {
  final int subscriptionId;
  final String? promotorCode;
  InitChargilyPaymentDto({required this.subscriptionId, this.promotorCode});
  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'promocode': promotorCode,
    };
  }
}
