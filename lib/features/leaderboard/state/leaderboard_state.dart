import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';

class LeaderboardState extends Equatable {
  final AsyncValue<List<LeaderboardUser>> leaderboardUsers;
  final bool isFetchingMore;
  final int page;
  final int totalPages;

  const LeaderboardState({
    required this.leaderboardUsers,
    required this.isFetchingMore,
    required this.page,
    required this.totalPages,
  });

  factory LeaderboardState.initial() {
    return const LeaderboardState(
      leaderboardUsers: AsyncValue.loading(),
      isFetchingMore: false,
      page: 1,
      totalPages: 1,
    );
  }

  bool get canLoadMore => page < totalPages;

  bool get hasData => leaderboardUsers.asData?.value.isNotEmpty ?? false;

  List<LeaderboardUser> get userList => leaderboardUsers.asData?.value ?? [];

  LeaderboardState copyWith({
    AsyncValue<List<LeaderboardUser>>? leaderboardUsers,
    bool? isFetchingMore,
    int? page,
    int? totalPages,
  }) {
    return LeaderboardState(
      leaderboardUsers: leaderboardUsers ?? this.leaderboardUsers,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  LeaderboardState setIsLoading() {
    return copyWith(leaderboardUsers: const AsyncValue.loading());
  }

  LeaderboardState copyWithError(AppException error) {
    return copyWith(
        leaderboardUsers:
            AsyncValue.error(error, error.stackTrace ?? StackTrace.current));
  }

  LeaderboardState copyWithData(List<LeaderboardUser> leaderboardUsers,
      {int? totalPages}) {
    return copyWith(
        leaderboardUsers: AsyncValue.data(leaderboardUsers),
        totalPages: totalPages ?? this.totalPages);
  }

  LeaderboardState setIsFetchingMore(bool isFetchingMore) {
    return copyWith(isFetchingMore: isFetchingMore);
  }

  LeaderboardState joinData(List<LeaderboardUser> newItems) {
    final currentItems = userList;
    final allItems = [...currentItems, ...newItems];
    return copyWith(
      leaderboardUsers: AsyncValue.data(allItems),
      page: page + 1,
    );
  }

  @override
  List<Object?> get props =>
      [leaderboardUsers, isFetchingMore, page, totalPages];
}
