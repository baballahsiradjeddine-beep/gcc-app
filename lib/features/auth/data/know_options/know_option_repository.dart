import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_model.dart';
import 'package:tayssir/features/auth/data/know_options/know_option_remote_data_source.dart';

abstract class KnowOptionRepository {
  Future<List<KnowOptionModel>> getKnowOptions();
}

class KnowOptionRepositoryImpl implements KnowOptionRepository {
  final KnowOptionRemoteDataSource remoteDataSource;

  KnowOptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<KnowOptionModel>> getKnowOptions() async {
    try {
      final response = await remoteDataSource.getKnowOptions();
      final data = response.data['data'] as List;
      return data
          .map<KnowOptionModel>((e) => KnowOptionModel.fromJson(e))
          .toList();
    } catch (e, st) {
      //TODO:ERROR HANDLING
      AppLogger.logError('Error fetching know options: $e\n$st');
      rethrow;
    }
  }
}

final knowOptionRepositoryProvider = Provider<KnowOptionRepository>((ref) {
  final remoteDataSource = ref.watch(knowOptionRemoteDataSourceProvider);
  return KnowOptionRepositoryImpl(remoteDataSource: remoteDataSource);
});
