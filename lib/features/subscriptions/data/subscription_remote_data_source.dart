import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/features/subscriptions/data/init_chargily_payment_dto.dart';
import 'package:tayssir/features/subscriptions/data/upload_payement_proof_dto.dart';
import 'package:tayssir/providers/dio/dio.dart';

class SubscriptionRemoteDataSource {
  final DioClient dioClient;
  SubscriptionRemoteDataSource(this.dioClient);

  Future<Response> subscribeWithCard(String cardNumber) async {
    final response = await dioClient.post(
      EndPoints.subscribe,
      data: {
        'card_code': cardNumber,
      },
    );

    return response;
  }

  Future<Response> subscribeWithPaper(
      {required UploadPaymentProofDto dto}) async {
    final data = dto.toJson();
    final formData = FormData.fromMap(data);
    formData.files.add(MapEntry(
        'attachment',
        MultipartFile.fromFileSync(
          dto.attachment.path,
        )));
    final response = await dioClient.postFormData(
      EndPoints.subscribeWithPaper,
      formData: formData,
      // data: dto.toJson(),
    );

    return response;
  }

  Future<Response> initChargilyPayment(
    InitChargilyPaymentDto dto,
  ) async {
    final response = await dioClient.post(
      EndPoints.subscribeWithChargily,
      data: dto.toJson(),
    );

    return response;
  }

  Future<Response> getSubscriptions() async {
    final response = await dioClient.getStaticContent(EndPoints.subscriptions);
    return response;
  }
}

final subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SubscriptionRemoteDataSource(dioClient);
});
