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
    return AppScaffold(
      paddingB: 0,
      topSafeArea: false,
      paddingY: 60.h,
      appBar: Row(
        children: [
          //back button
          48.horizontalSpace,
          const Spacer(),
          const Text(
            'الإشعارات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Spacer(),
          // const SizedBox(width: 48),
          //back button
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.black, size: 20),
            onPressed: () {
              // Navigator.of(context).pop();
              context.pop();
            },
          ),
        ],
      ),
      body: controller.notifications.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد إشعارات متاحة.',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return PaginatedListView<NotificationModel>(
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
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            'خطأ: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
