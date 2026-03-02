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
    final leaderboard = ref.watch(leaderboardControllerProvider).leaderboardUsers.asData?.value ?? [];
    final top3 = leaderboard.take(3).toList();
    final others = leaderboard.skip(3).toList();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      topSafeArea: true,
      paddingX: 0,
      paddingB: 0,
      bodyBackgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(context, ref, isDark),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(leaderboardControllerProvider),
              color: const Color(0xFF00B4D8),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (ref.watch(leaderboardControllerProvider).leaderboardUsers.isLoading)
                    const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Color(0xFF00B4D8))))
                  else if (leaderboard.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'لا توجد بيانات للمتصدرين بعد',
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'SomarSans'),
                        ),
                      ),
                    )
                  else ...[
                    // Podium Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black45 : Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (top3.length > 1)
                            PodiumUserWidget(
                              user: top3[1],
                              place: 2,
                              size: 85.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ),
                          if (top3.isNotEmpty)
                            PodiumUserWidget(
                              user: top3[0],
                              place: 1,
                              size: 105.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ),
                          if (top3.length > 2)
                            PodiumUserWidget(
                              user: top3[2],
                              place: 3,
                              size: 75.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ),
                        ],
                      ),
                    ),
                      ),
                    ),

                    // Others List
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < others.length) {
                              return LeaderboardListTile(
                                user: others[index],
                                rank: index + 4,
                                isDark: isDark,
                              );
                            } else if (controller.canLoadMore) {
                              if (!controller.isFetchingMore) {
                                Future.microtask(() => ref.read(leaderboardControllerProvider.notifier).fetchMoreLeaderboard());
                              }
                              return const Center(child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
                              ));
                            }
                            return null;
                          },
                          childCount: others.length + (controller.canLoadMore ? 1 : 0),
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(child: 100.verticalSpace),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          const SizedBox(width: 44), // Spacer for balance
          const Spacer(),
          Text(
            'لوحة المتصدرين',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              fontFamily: 'SomarSans',
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              final user = ref.watch(userNotifierProvider).valueOrNull;
              if (user != null) {
                AppLogger.sendLog(
                  email: user.email,
                  type: LogType.subscriptions,
                  content: 'Refresh leaderboard Pressed',
                );
              }
              ref.invalidate(leaderboardControllerProvider);
            },
            child: Container(
              width: 44.sp,
              height: 44.sp,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: const Color(0xFF00B4D8),
                size: 26.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
