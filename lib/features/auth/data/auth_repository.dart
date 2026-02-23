import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/auth/data/change_password_request.dart';
import 'package:tayssir/features/auth/data/exist_response.dart';

import '../../../providers/token/tokens_model.dart';
import '../../../utils/extensions/response.dart';
import 'local_auth_data_source.dart';
import 'requests/login_request_model.dart';
import 'requests/register_request_model.dart';
import 'remote_auth_data_source.dart';

final authRepoProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    remoteAuthDataSource: ref.watch(remoteAuthDataSourceProvider),
    localAuthDataSource: ref.watch(localAuthDataSourceProvider),
    // googleService: ref.watch(googleServiceProvider),
  );
});

class AuthRepository {
  AuthRepository({
    required RemoteAuthDataSource remoteAuthDataSource,
    required LocalAuthDataSource localAuthDataSource,
    // for now i will use service in here , maybe refectored later on
    // required GoogleService googleService,
  })  : _remoteAuthDataSource = remoteAuthDataSource,
        _localAuthDataSource = localAuthDataSource;
  // _googleService = googleService;
  final RemoteAuthDataSource _remoteAuthDataSource;
  final LocalAuthDataSource _localAuthDataSource;
  // final GoogleService _googleService;
  Future<void> login(String email, String password) async {
    try {
      final response = await _remoteAuthDataSource.login(
          loginModel: LoginRequestModel(email: email, password: password));
      response.throwIfNotSuccessful();

      final data = response.customData;
      final tokensModel = TokensModel.fromMap(data);
      _localAuthDataSource.saveTokens(tokensModel);
    } on DioException catch (e) {
      // TODO:same here to a app exception
      throw AppException.fromDioResponse(e.response!);
    }
  }

  Future<void> register(CreateAccountRequestModel model) async {
    final response = await _remoteAuthDataSource.register(
      registerModel: model,
    );
    response.throwIfNotSuccessful();
    final data = response.customData;
    final tokensModel = TokensModel.fromMap(data);
    _localAuthDataSource.saveTokens(tokensModel);
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response =
          await _remoteAuthDataSource.checkEmailExists(email: email);
      // response.throwIfNotSuccessful();
      return ExistResponse.fromMap(response.data['data']).exists;
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final response = await _remoteAuthDataSource.checkPhoneNumberExists(
          phoneNumber: phoneNumber);
      // response.throwIfNotSuccessful();
      return ExistResponse.fromMap(response.data['data']).exists;
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> sendEmailOtpCode(String email) async {
    try {
      final response =
          await _remoteAuthDataSource.sendEmailOtpCode(email: email);
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> sendVerifyEmailOtpCode() async {
    try {
      final response = await _remoteAuthDataSource.sendVerifyEmailOtpCode();
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> verifyUser(String code) async {
    try {
      final response = await _remoteAuthDataSource.verifyUser(code: code);
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> verifyEmailOtpCode(String email, String code) async {
    try {
      final response = await _remoteAuthDataSource.verifyEmailOtpCode(
          email: email, code: code);
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> sendForgetPasswordOtpCode(String email) async {
    try {
      final response =
          await _remoteAuthDataSource.sendForgetPasswordOtpCode(email: email);
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> verifyForgetPasswordOtpCode(String email, String code) async {
    try {
      final response = await _remoteAuthDataSource.verifyForgetPasswordOtpCode(
          email: email, code: code);
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> changeForgetPassword(
      String email, String code, String password) async {
    final response = await _remoteAuthDataSource.changeForgetPassword(
        email: email, code: code, password: password);
    response.throwIfNotSuccessful();
  }

  void clearToken() {
    return _localAuthDataSource.clearTokens();
  }

  void saveToken(String token) {
    return _localAuthDataSource.saveToken(token);
  }

  Future<void> resetPassword(String password, String newPassword) async {
    try {
      final data = ChangePasswordRequest(
          oldPassword: password, newPassword: newPassword);
      final response = await _remoteAuthDataSource.changePassword(data: data);
      response.throwIfNotSuccessful();
      return;
    } on DioException catch (e) {
      throw AppException.fromDioResponse(e.response!);
    }
  }

  // ----------- CHANGE EMAIL SECTION 0

  Future<void> sendChangeEmailOtpCode(String email) async {
    try {
      final response = await _remoteAuthDataSource.sendChangeEmailOtpCode(
        email: email,
      );
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> verifyChangeEmailOtpCode(String email, String code) async {
    try {
      final response = await _remoteAuthDataSource.verifyChangeEmail(
        email: email,
        code: code,
      );
      response.throwIfNotSuccessful();
    } on DioException catch (e) {
      throw DioException(
        response: e.response,
        error: e.error,
        message: e.response!.errorMessage,
        requestOptions: e.requestOptions,
      );
    }
  }

  Future<void> signInGoogle({required String idToken}) async {
    try {
      final response =
          await _remoteAuthDataSource.googleLogin(idToken: idToken);
      response.throwIfNotSuccessful();
      final data = response.customData;
      final tokensModel = TokensModel.fromMap(data);
      _localAuthDataSource.saveTokens(tokensModel);
    } on DioException catch (e) {
      throw AppException.fromDioResponse(e.response!);
    }
  }

  Future<void> signUpGoogle(GoogleSignUpRequest request) async {
    try {
      final response = await _remoteAuthDataSource.googleRegister(
        request,
      );
      response.throwIfNotSuccessful();
      final data = response.customData;
      final tokensModel = TokensModel.fromMap(data);
      _localAuthDataSource.saveTokens(tokensModel);
    } on DioException catch (e) {
      throw AppException.fromDioResponse(e.response!);
    }
  }

  // void signWithGoogle() async {
//   final account = await _googleService.signIn();
  //   if (account != null) {
  //     //TODO:
  //     final response = await _remoteAuthDataSource.login(
  //         loginModel:
  //             LoginRequestModel(email: account.email, password: account.id));
  //     response.throwIfNotSuccessful();
  //     final data = response.data as Map<String, dynamic>;
  //     final tokensModel = TokensModel.fromMap(data);
  //     _localAuthDataSource.saveTokens(tokensModel);
  //   }
  // }

  // Future<void> signOut() async {
  //   await _googleService.signOut();
  //   clearToken();
  // }
}

class GoogleSignUpRequest {
  GoogleSignUpRequest({
    required this.idToken,
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.wilayaId,
    required this.communeId,
    required this.divisionId,
    required this.referralSourceId,
  });

  final String idToken;
  final String name;
  final String phoneNumber;
  final int age;
  final int wilayaId;
  final int communeId;
  final int divisionId;
  final int referralSourceId;

  Map<String, dynamic> toMap() {
    return {
      'id_token': idToken,
      'name': name,
      'phone_number': phoneNumber,
      'age': age,
      'wilaya_id': wilayaId,
      'commune_id': communeId,
      'division_id': divisionId,
      'referral_source_id': referralSourceId,
    };
  }
}
