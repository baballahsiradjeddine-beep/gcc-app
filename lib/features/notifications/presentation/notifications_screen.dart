import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';
import 'package:tayssir/features/notifications/presentation/notification_card.dart';
import 'package:tayssir/features/notifications/presentation/notifications_controller.dart';
import 'package:tayssir/features/notifications/presentation/paginated_list_view.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(notificationsControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      includeBackButton: true,
      topSafeArea: true,
      paddingB: 0,
      paddingY: 10.h,
      bodyBackgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      appBar: Text(
        'مركز الإشعارات 🔔',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontFamily: 'SomarSans',
        ),
      ),
      body: Column(
        children: [
          10.verticalSpace,
          Expanded(
            child: controller.notifications.when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30.w),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_off_outlined,
                            size: 80.sp,
                            color: isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          'لا توجد إشعارات حالياً',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                          ),
                        ),
                        8.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            'سنقوم بإعلامك فور وصول أي تحديثات أو تنبيهات هامة لك!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white38 : const Color(0xFF64748B),
                              fontSize: 14.sp,
                              height: 1.5,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
                }

                return PaginatedListView<NotificationModel>(
                  padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                  data: data,
                  canLoadMore: controller.canLoadMore,
                  isFetchingMore: controller.isFetchingMore,
                  onLoadMore: () => ref
                      .read(notificationsControllerProvider.notifier)
                      .fetchMoreNotifications(),
                  itemBuilder: (context, item, index) {
                    return NotificationCard(
                      notification: item,
                    ).animate()
                     .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                     .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
                  },
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF00B4D8),
                        strokeWidth: 3,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      'جاري تحميل الإشعارات...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontFamily: 'SomarSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 40),
                    12.verticalSpace,
                    Text(
                      'حدث خطأ في جلب البيانات',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SomarSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
