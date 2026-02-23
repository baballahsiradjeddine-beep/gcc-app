import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/features/settings/domaine/contact_us_model.dart';
import 'package:tayssir/providers/dio/dio.dart';

class RemoteSettingsDataSource {
  final DioClient dioClient;
  RemoteSettingsDataSource(this.dioClient);

  Future<void> sendContactUs(ContactUsModel contactUsModel) async {
    try {
      await dioClient.post(
        EndPoints.contactUs,
        data: contactUsModel.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
