import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';
import 'package:tayssir/features/notifications/presentation/notification_card.dart';
import 'package:tayssir/features/notifications/presentation/notifications_controller.dart';
import 'package:tayssir/features/notifications/presentation/paginated_list_view.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(notificationsControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      paddingB: 0,
      topSafeArea: true,
      paddingY: 0,
      paddingX: 0,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.white, const Color(0xFFF8FAFC)],
          ),
        ),
        child: Column(
          children: [
            // Custom Premium AppBar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, 
                        color: isDark ? Colors.white : const Color(0xFF1E293B), size: 20.sp),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'مركز الإشعارات',
                    style: TextStyle(
                      fontWeight: FontWeight.w900, 
                      fontSize: 20.sp,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w), // Balance for back button
                ],
              ),
            ),

            Expanded(
              child: controller.notifications.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "📭",
                            style: TextStyle(fontSize: 60.sp),
                          ),
                          20.verticalSpace,
                          Text(
                            'لا توجد إشعارات حالياً',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : const Color(0xFF64748B),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            'سنخبرك عندما يكون هناك شيء جديد!',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                              fontSize: 14.sp,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return PaginatedListView<NotificationModel>(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    data: data,
                    canLoadMore: controller.canLoadMore,
                    isFetchingMore: controller.isFetchingMore,
                    onLoadMore: () => ref
                        .read(notificationsControllerProvider.notifier)
                        .fetchMoreNotifications(),
                    itemBuilder: (context, item, index) {
                      return NotificationCard(
                        notification: item,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'خطأ: $error',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
