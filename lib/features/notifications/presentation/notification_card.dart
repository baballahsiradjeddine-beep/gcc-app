import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';
import 'package:tayssir/features/notifications/presentation/notifications_controller.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: notification.isRead 
            ? (isDark ? const Color(0xFF1E293B).withOpacity(0.5) : const Color(0xFFF8FAFC))
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: notification.isRead 
              ? (isDark ? const Color(0xFF334155).withOpacity(0.3) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF00B4D8).withOpacity(0.5) : const Color(0xFF00B4D8).withOpacity(0.2)),
          width: 1.5,
        ),
        boxShadow: [
          if (!notification.isRead)
            BoxShadow(
              color: const Color(0xFF00B4D8).withOpacity(isDark ? 0.1 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            if (!notification.isRead) {
              ref
                  .read(notificationsControllerProvider.notifier)
                  .markAsRead(notification.id);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: notification.isRead 
                            ? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))
                            : const Color(0xFF00B4D8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        notification.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                        size: 20.sp,
                        color: notification.isRead 
                            ? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))
                            : const Color(0xFF00B4D8),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: notification.isRead
                                  ? (isDark ? Colors.white60 : const Color(0xFF64748B))
                                  : (isDark ? Colors.white : const Color(0xFF1E293B)),
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                              fontFamily: 'SomarSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B4D8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00B4D8),
                              blurRadius: 4,
                            )
                          ]
                        ),
                      ),
                  ],
                ),
                16.verticalSpace,
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: notification.isRead
                        ? (isDark ? Colors.white38 : const Color(0xFF64748B))
                        : (isDark ? Colors.white70 : const Color(0xFF334155)),
                    height: 1.5,
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
