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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              notification.isRead ? Colors.grey.shade300 : Colors.blue.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
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
                    if (!notification.isRead)
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (!notification.isRead) 8.horizontalSpace,
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: notification.isRead
                              ? Colors.grey.shade600
                              : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: notification.isRead
                        ? Colors.grey.shade600
                        : Colors.black87,
                    height: 1.4,
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
