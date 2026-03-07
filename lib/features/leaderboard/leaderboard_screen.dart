import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/leaderboard/leaderboard_list_tile.dart';
import 'package:tayssir/features/leaderboard/leaderboard_user.dart';
import 'package:tayssir/features/leaderboard/podium_user_widget.dart';
import 'package:tayssir/features/leaderboard/state/leaderboard_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
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
      topSafeArea: false,
      paddingX: 0,
      paddingB: 0,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(leaderboardControllerProvider),
        color: AppColors.primaryColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Standardized Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomAppBar(
                      reverse: true, 
                      showNotifications: false,
                      showThemeToggle: false,
                      showLogo: false, // Prevent overlap with the title below
                    ),
                    Text(
                      "لوحة الشرف",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.textBlack,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                    SizedBox(width: 44.sp), // Balance
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            ),

            if (ref.watch(leaderboardControllerProvider).leaderboardUsers.isLoading && leaderboard.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
              )
            else if (ref.watch(leaderboardControllerProvider).leaderboardUsers.hasError && leaderboard.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'حدث خطأ أثناء تحميل البيانات',
                    style: TextStyle(fontSize: 16.sp, color: Colors.redAccent, fontFamily: 'SomarSans'),
                  ),
                ),
              )
            else if (leaderboard.isEmpty && !ref.watch(leaderboardControllerProvider).leaderboardUsers.isLoading)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events_outlined, size: 60.sp, color: Colors.grey.withOpacity(0.3)),
                      10.verticalSpace,
                      Text(
                        'لا توجد بيانات للمتصدرين بعد',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontFamily: 'SomarSans'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Podium Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBlue : AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          blurRadius: 40,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (top3.length > 1)
                          Expanded(
                            child: PodiumUserWidget(
                              user: top3[1],
                              place: 2,
                              size: 85.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                          ),
                        if (top3.isNotEmpty)
                          Expanded(
                            child: PodiumUserWidget(
                              user: top3[0],
                              place: 1,
                              size: 110.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ).animate().fadeIn().scale(duration: 400.ms, curve: Curves.easeOutBack).shimmer(delay: 2.seconds, duration: 2.seconds),
                          ),
                        if (top3.length > 2)
                          Expanded(
                            child: PodiumUserWidget(
                              user: top3[2],
                              place: 3,
                              size: 75.sp,
                              offsetY: 0,
                              isDark: isDark,
                            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
                  child: Text(
                    "أبطال الترتيب",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.textBlack,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),
              ),

              // Others List
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                       if (index < others.length) {
                        return LeaderboardListTile(
                          user: others[index],
                          rank: index + 4,
                          isDark: isDark,
                        ).animate().fadeIn(delay: (index * 40).clamp(0, 600).ms).slideY(begin: 0.05, end: 0);
                      } else if (controller.canLoadMore) {
                        if (!controller.isFetchingMore) {
                          Future.microtask(() => ref.read(leaderboardControllerProvider.notifier).fetchMoreLeaderboard());
                        }
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: AppColors.primaryColor),
                        ));
                      }
                      return null;
                    },
                    childCount: others.length + (controller.canLoadMore ? 1 : 0),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: 120.verticalSpace),
            ],
          ],
        ),
      ),
    );
  }
}
