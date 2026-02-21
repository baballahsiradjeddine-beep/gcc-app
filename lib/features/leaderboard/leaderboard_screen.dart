import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/leaderboard/leaderboard_list_tile.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/features/leaderboard/podium_user_widget.dart';
import 'package:tayssir/features/leaderboard/state/leaderboard_controller.dart';
import 'package:tayssir/features/notifications/presentation/paginated_list_view.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';


class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(leaderboardControllerProvider);
    final leaderboard = ref
            .watch(leaderboardControllerProvider)
            .leaderboardUsers
            .asData
            ?.value ??
        [];
    final top3 = leaderboard.take(3).toList();
    final others = leaderboard.skip(3).toList();

    return AppScaffold(
      paddingB: 0,
      appBar: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryColor),
            onPressed: () {
              AppLogger.sendLog(
                email: ref.watch(userNotifierProvider).requireValue!.email,
                type: LogType.subscriptions,
                content: 'Refresh leaderboard Pressed',
              );
              ref.invalidate(leaderboardControllerProvider);
            },
          ),
          const Spacer(),
          const Text(
            'لوحة المتصدرين',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
      body: ref.watch(leaderboardControllerProvider).leaderboardUsers.isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboard.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد بيانات للمتصدرين بعد',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : // if its not empty , show the leaderboard

              Column(
                  children: [
                    Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PodiumUserWidget(
                            user: top3[1],
                            place: 2,
                            size: 90,
                            offsetY: 35,
                          ),
                          PodiumUserWidget(
                            user: top3[0],
                            place: 1,
                            size: 110,
                            offsetY: 0,
                          ),
                          PodiumUserWidget(
                            user: top3[2],
                            place: 3,
                            size: 80,
                            offsetY: 50,
                          ),
                        ],
                      ),
                    ),
                    5.verticalSpace,
                    Expanded(
                        child: PaginatedListView<LeaderboardUser>(
                      data: others,
                      canLoadMore: controller.canLoadMore,
                      isFetchingMore: controller.isFetchingMore,
                      onLoadMore: () => ref
                          .read(leaderboardControllerProvider.notifier)
                          .fetchMoreLeaderboard(),
                      itemBuilder: (context, item, index) {
                        return LeaderboardListTile(
                          user: item,
                          rank: index + 4,
                        );
                      },
                    ))
                  ],
                ),
    );
  }
}
