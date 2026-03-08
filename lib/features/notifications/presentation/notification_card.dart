import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';
import 'package:tayssir/features/notifications/presentation/notifications_controller.dart';
import 'package:tayssir/resources/colors/app_colors.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark 
            ? (notification.isRead ? const Color(0xFF1E293B).withOpacity(0.3) : const Color(0xFF1E293B))
            : (notification.isRead ? Colors.white.withOpacity(0.6) : Colors.white),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark 
              ? (notification.isRead ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1))
              : (notification.isRead ? Colors.grey.withOpacity(0.1) : Colors.white),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {
            if (!notification.isRead) {
              ref
                  .read(notificationsControllerProvider.notifier)
                  .markAsRead(notification.id);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: notification.isRead 
                            ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05))
                            : const Color(0xFF00B4D8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        notification.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                        size: 22.sp,
                        color: notification.isRead 
                            ? (isDark ? Colors.white30 : Colors.grey.shade400)
                            : const Color(0xFF00B4D8),
                      ),
                    ),
                    14.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: notification.isRead
                                  ? (isDark ? Colors.white38 : Colors.grey.shade500)
                                  : (isDark ? Colors.white : const Color(0xFF1E293B)),
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4D8).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'جديد',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00B4D8),
                            fontFamily: 'SomarSans',
                          ),
                        ),
                      ),
                  ],
                ),
                16.verticalSpace,
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: notification.isRead
                        ? (isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade400)
                        : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    height: 1.6,
                    fontFamily: 'SomarSans',
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
