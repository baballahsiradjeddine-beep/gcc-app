import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/constants/end_points.dart';
import 'package:tayssir/providers/dio/dio.dart';
import 'package:tayssir/services/user/update_user_request.dart';

class RemoteUserDataSource {
  final DioClient dioClient;

  RemoteUserDataSource({required this.dioClient});

  Future<Response> getUser() async {
    final response = await dioClient.get(EndPoints.getUser);
    return response;
  }

  Future<Response> updateUser(UpdateUserRequest updateUserRequest) async {
    final data = updateUserRequest.toMap();
    final formData = FormData.fromMap(data);
    if (updateUserRequest.image != null) {
      formData.files.add(MapEntry(
          'profile_picture',
          MultipartFile.fromFileSync(
            updateUserRequest.image!.path,
          )));
    }
    final response =
        await dioClient.postFormData(EndPoints.updateUser, formData: formData);
    return response;
  }
}

final remoteUserDataSourceProvider = Provider<RemoteUserDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RemoteUserDataSource(dioClient: dioClient);
});
