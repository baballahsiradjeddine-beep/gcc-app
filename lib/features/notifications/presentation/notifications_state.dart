import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/exceptions/app_exception.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';

class NotificationsState extends Equatable {
  final AsyncValue<List<NotificationModel>> notifications;
  final bool isFetchingMore;
  final int page;
  final int totalPages;

  const NotificationsState({
    required this.notifications,
    required this.isFetchingMore,
    required this.page,
    required this.totalPages,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      notifications: AsyncValue.loading(),
      isFetchingMore: false,
      page: 1,
      totalPages: 1,
    );
  }

  bool get canLoadMore => page < totalPages;

  bool get hasData => notifications.asData?.value.isNotEmpty ?? false;

  List<NotificationModel> get notifList => notifications.asData?.value ?? [];

  NotificationsState copyWith({
    AsyncValue<List<NotificationModel>>? notifications,
    bool? isFetchingMore,
    int? page,
    int? totalPages,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  NotificationsState setIsLoading() {
    return copyWith(notifications: const AsyncValue.loading());
  }

  NotificationsState copyWithError(AppException error) {
    return copyWith(
        notifications:
            AsyncValue.error(error, error.stackTrace ?? StackTrace.current));
  }

  NotificationsState copyWithData(List<NotificationModel> notifications,
      {int? totalPages}) {
    return copyWith(
        notifications: AsyncValue.data(notifications),
        totalPages: totalPages ?? this.totalPages);
  }

  NotificationsState setIsFetchingMore(bool isFetchingMore) {
    return copyWith(isFetchingMore: isFetchingMore);
  }

  NotificationsState joinData(List<NotificationModel> newItems) {
    final currentItems = notifList;
    final allItems = [...currentItems, ...newItems];
    return copyWith(
      notifications: AsyncValue.data(allItems),
      page: page + 1,
    );
  }

  @override
  List<Object?> get props => [notifications, isFetchingMore, page, totalPages];
}
