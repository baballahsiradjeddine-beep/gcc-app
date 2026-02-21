import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/features/notifications/data/notifications_repository.dart';
import 'package:tayssir/features/notifications/presentation/notifications_state.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import '../../../exceptions/app_exception.dart';

class NotificationsController extends StateNotifier<NotificationsState> {
  final NotificationsRepository _notificationRepository;
  final Ref ref;

  NotificationsController(this._notificationRepository, this.ref)
      : super(NotificationsState.initial()) {
    getNotifications();
  }

  bool isMarkingAsRead = false;

  Future<void> getNotifications() async {
    state = state.setIsLoading();
    try {
      final data = await _notificationRepository.getNotifications();
      state = state.copyWithData(data.data, totalPages: data.totalPages);
    } catch (e) {
      state = state
          .copyWithError(AppException.fromDartException(e, StackTrace.current));
    }
  }

  Future<void> fetchMoreNotifications() async {
    if (state.isFetchingMore) return;
    if (!state.canLoadMore) return;
    if (!state.hasData) return;
    state = state.setIsFetchingMore(true);
    try {
      final newData =
          await _notificationRepository.getNotifications(page: state.page + 1);
      state = state.joinData(newData.data);
    } catch (e) {
      // state = state.copyWithError(e);
      state = state
          .copyWithError(AppException.fromDartException(e, StackTrace.current));
    } finally {
      state = state.setIsFetchingMore(false);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (!state.hasData) return;
    if (isMarkingAsRead) return;
    try {
      isMarkingAsRead = true;
      await _notificationRepository.markAsRead(id: notificationId);
      markAsReadToggle(notificationId);
      checkThereIsNoMoreUnreadNotifications();
    } on AppException catch (_) {
      markAsReadToggle(notificationId);
    } finally {
      isMarkingAsRead = false;
    }
  }

  void markAsReadToggle(String notificationId) {
    final updatedNotifications = state.notifList.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: !notification.isRead);
      }
      return notification;
    }).toList();

    state = state.copyWithData(updatedNotifications);
  }

  void checkThereIsNoMoreUnreadNotifications() {
    if (!state.hasData) return;
    final hasUnread =
        state.notifList.any((notification) => !notification.isRead);
    if (!hasUnread) {
      ref
          .read(userNotifierProvider.notifier)
          .setUserNewNotificationsStatus(false);
    }
  }
}

final notificationsControllerProvider = StateNotifierProvider.autoDispose<
    NotificationsController, NotificationsState>(
  (ref) =>
      NotificationsController(ref.watch(notificationsRepositoryProvider), ref),
);
