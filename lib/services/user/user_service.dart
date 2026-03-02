import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/services/user/update_user_request.dart';
import 'package:tayssir/services/user/user_repository.dart';

import '../../providers/user/user_model.dart';

class LocalDataSource {}

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

final userServiceProvider = Provider<UserService>((ref) {
  final userRepo = ref.watch(userRepoProvider);
  return UserService(userRepository: userRepo, ref);
});

class UserService {
  final UserRepository userRepository;
  final Ref ref;
  UserService(this.ref, {required this.userRepository});

  Future<UserModel> getUser() async {
    return userRepository.getUser();
  }

  Future<UserModel> updateUser(UpdateUserRequest userReq) async {
    // can do optional validation here
    return await userRepository.updateUser(userReq);
  }
}
