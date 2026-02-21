import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/leaderboard/data/leaderboard_remote_data_source.dart';
import 'package:tayssir/features/leaderboard/data/leaderboard_repository.dart';
import 'package:tayssir/features/leaderboard/leaderboard_screen.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/features/notifications/data/paginated_data.dart';

class LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;

  LeaderboardRepository({
    required this.remoteDataSource,
  });

  Future<PaginatedData<LeaderboardUser>> getLeaderboard({int page = 1}) async {
    try {
      final response = await remoteDataSource.getLeaderboard(page);
      final data = response.data['data']['data'];
      final leaderboard =
          data.map<LeaderboardUser>((e) => LeaderboardUser.fromMap(e)).toList();
      final totalPages = response.data['data']['total_pages'] as int;
      return PaginatedData(
        data: leaderboard,
        totalPages: totalPages,
        page: page,
      );
    } catch (e, st) {
      AppLogger.logError('Error fetching leaderboard: $e');
      return PaginatedData(data: [], totalPages: 0, page: 1);
    }
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) {
    final remoteDataSource = ref.watch(leaderboardRemoteDataSourceProvider);
    return LeaderboardRepository(
      remoteDataSource: remoteDataSource,
    );
  },
);
