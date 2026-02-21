import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/auth/data/auth_repository.dart';
import 'package:tayssir/features/auth/data/change_password_request.dart';

import '../../../providers/dio/dio.dart';
import '../../../constants/end_points.dart';
import 'requests/login_request_model.dart';
import 'requests/register_request_model.dart';

final remoteAuthDataSourceProvider = Provider<RemoteAuthDataSource>((ref) {
  return RemoteAuthDataSource(dioClient: ref.watch(dioClientProvider));
});

class RemoteAuthDataSource {
  final DioClient _dioClient;

  RemoteAuthDataSource({required dioClient}) : _dioClient = dioClient;

  Future<Response> login({required LoginRequestModel loginModel}) async {
    final response = await _dioClient.post(
      EndPoints.login,
      data: loginModel.toJson(),
    );

    return response;
  }

  Future<Response> register(
      {required CreateAccountRequestModel registerModel}) async {
    AppLogger.logInfo('registerModel: ${registerModel.toJson()}');
    final response = await _dioClient.post(EndPoints.register,
        data: registerModel.toJson(), contentType: Headers.jsonContentType);
    return response;
  }

  // Future<Response> fetchUserInfo() async {
  //   final response = await _dioClient.get(
  //     EndPoints.userInfo,
  //   );
  //   return response;
  // }

  Future<Response> checkEmailExists({required String email}) async {
    final response = await _dioClient.post(
      EndPoints.checkEmailExists,
      data: {"email": email},
    );
    return response;
  }

  Future<Response> checkPhoneNumberExists({required String phoneNumber}) async {
    final response = await _dioClient.post(
      EndPoints.checkPhoneNumberExists,
      data: {"phone_number": phoneNumber},
    );
    return response;
  }

  Future<Response> sendEmailOtpCode({required String email}) async {
    final response = await _dioClient.post(
      EndPoints.sendOtpCode,
      data: {"email": email},
    );
    return response;
  }

  Future<Response> verifyEmailOtpCode(
      {required String email, required String code}) async {
    final response = await _dioClient.post(
      EndPoints.verifyOtpCode,
      data: {"otp": code, "email": email},
    );
    return response;
  }

  Future<Response> sendForgetPasswordOtpCode({required String email}) async {
    final response = await _dioClient.post(
      EndPoints.forgotPassword,
      data: {"email": email},
    );
    return response;
  }

  Future<Response> verifyForgetPasswordOtpCode(
      {required String email, required String code}) async {
    final response = await _dioClient.post(
      EndPoints.forgetPasswordverifyCode,
      data: {"otp": code, "email": email},
    );
    return response;
  }

  Future<Response> changeForgetPassword(
      {required String email,
      required String code,
      required String password}) async {
    final response = await _dioClient.post(
      EndPoints.resetPassword,
      data: {
        "otp": code,
        "email": email,
        "new_password": password,
        'new_password_confirmation': password
      },
    );
    return response;
  }

  //reset password
  Future<Response> changePassword({required ChangePasswordRequest data}) async {
    final response = await _dioClient.put(
      EndPoints.changePassword,
      data: data.toMap(),
    );
    return response;
  }

  Future<Response> sendChangeEmailOtpCode({required String email}) async {
    final response = await _dioClient.post(
      EndPoints.changeEmail,
      data: {"new_email": email},
    );
    return response;
  }

  Future<Response> verifyChangeEmail(
      {required String email, required String code}) async {
    final response = await _dioClient.post(
      EndPoints.verifyEmail,
      data: {"otp": code, "email": email},
    );
    return response;
  }

  Future<Response> googleLogin({required String idToken}) async {
    final response = await _dioClient.post(
      EndPoints.googleLogin,
      data: {'id_token': idToken},
    );
    return response;
  }

  Future<Response> googleRegister(GoogleSignUpRequest request) async {
    final response = await _dioClient.post(
      EndPoints.googleRegister,
      data: request.toMap(),
    );
    return response;
  }

  Future<Response> sendVerifyEmailOtpCode() async {
    final response = await _dioClient.post(
      EndPoints.sendVerifyEmailOtp,
      data: {},
    );
    return response;
  }

  Future<Response> verifyUser({required String code}) async {
    final response = await _dioClient.post(
      EndPoints.verifyUser,
      data: {"otp": code},
    );
    return response;
  }
}
