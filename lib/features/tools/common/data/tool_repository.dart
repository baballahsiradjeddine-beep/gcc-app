import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/tools/bacs/models/bacs_data_model.dart';
import 'package:tayssir/features/tools/card_swipper/models/card_data_model.dart';
import 'package:tayssir/features/tools/common/data/tool_remote_data_source.dart';
import 'package:tayssir/features/tools/resumes/models/resume_data_model.dart';

final toolRepositoryProvider = Provider<ToolRepository>((ref) {
  final remoteDataSource = ref.watch(toolRemoteDataSourceProvider);
  return ToolRepository(remoteDataSource: remoteDataSource);
});

class ToolRepository {
  final ToolRemoteDataSource remoteDataSource;

  ToolRepository({
    required this.remoteDataSource,
  });

  Future<CardDataModel> getCardsData({int page = 1}) async {
    try {
      final response = await remoteDataSource.getCardsData();
      final data = response.data['data'] as Map<String, dynamic>;
      return CardDataModel.fromMap(data);
    } catch (e) {
      AppLogger.logError('Error fetching cards data: $e');
      rethrow;
    }
  }

  Future<ResumeDataModel> getResumesData({int page = 1}) async {
    try {
      final response = await remoteDataSource.getResumesData();
      final data = response.data['data'] as Map<String, dynamic>;
      return ResumeDataModel.fromJson(data);
    } catch (e) {
      AppLogger.logError('Error fetching resumes data: $e');
      rethrow;
    }
  }

  Future<BacsDataModel> getBacsData() async {
    try {
      final response = await remoteDataSource.getBacsData();
      AppLogger.logInfo(response);
      final data = response.data['data'] as Map<String, dynamic>;
      return BacsDataModel.fromJson(data);
    } catch (e) {
      AppLogger.logError('Error fetching bacs data: $e');
      rethrow;
    }
  }
}
