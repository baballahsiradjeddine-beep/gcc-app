import 'dart:io';

class UploadPaymentProofDto {
  final int subscriptionId;
  final String? promotorCode;
  final File attachment;

  UploadPaymentProofDto({
    required this.subscriptionId,
    this.promotorCode,
    required this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'promocode': promotorCode,
      // 'attachment': attachment,
    };
  }
}
