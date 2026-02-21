import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/user/user_model.dart';
import 'package:tayssir/services/user/remote_user_data_source.dart';
import 'package:tayssir/services/user/update_user_request.dart';
import 'package:tayssir/services/user/user_service.dart';
import 'package:tayssir/utils/extensions/response.dart';

class UserRepository {
  UserRepository(
      {required this.remoteDataSource, required this.localDataSource});

  final RemoteUserDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  Future<UserModel> getUser() async {
    final response = await remoteDataSource.getUser();
    final userJson = response.getUser;
    AppLogger.logInfo('User: $userJson');
    final user = UserModel.fromMap(userJson);
    return user;
  }

  Future<UserModel> updateUser(UpdateUserRequest userReq) async {
    try {
      final response = await remoteDataSource.updateUser(userReq);
      if (response.isSuccessful) {
        return UserModel.fromMap(response.getUser);
      } else {
        throw Exception(response.errorMessage);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final userRepoProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(remoteUserDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return UserRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
