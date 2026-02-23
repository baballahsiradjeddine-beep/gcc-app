import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/leaderboard/data/leaderboard_repository.dart';
import 'package:tayssir/features/leaderboard/state/leaderboard_state.dart';
import '../../../exceptions/app_exception.dart';

class LeaderboardController extends StateNotifier<LeaderboardState> {
  final LeaderboardRepository _leaderboardRepository;
  final Ref ref;

  LeaderboardController(this._leaderboardRepository, this.ref)
      : super(LeaderboardState.initial()) {
    getLeaderboard();
  }

  Future<void> getLeaderboard() async {
    state = state.setIsLoading();
    try {
      final data = await _leaderboardRepository.getLeaderboard();
      state = state.copyWithData(data.data, totalPages: data.totalPages);
    } catch (e) {
      state = state
          .copyWithError(AppException.fromDartException(e, StackTrace.current));
    }
  }

  Future<void> fetchMoreLeaderboard() async {
    if (state.isFetchingMore) return;
    if (!state.canLoadMore) return;
    if (!state.hasData) return;
    state = state.setIsFetchingMore(true);
    try {
      final newData =
          await _leaderboardRepository.getLeaderboard(page: state.page + 1);
      state = state.joinData(newData.data);
    } catch (e) {
      state = state
          .copyWithError(AppException.fromDartException(e, StackTrace.current));
    } finally {
      state = state.setIsFetchingMore(false);
    }
  }
}

final leaderboardControllerProvider = StateNotifierProvider.autoDispose<
    LeaderboardController, LeaderboardState>(
  (ref) =>
      LeaderboardController(ref.watch(leaderboardRepositoryProvider), ref),
);