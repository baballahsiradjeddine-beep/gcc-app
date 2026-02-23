import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/notifications/data/paginated_data.dart';
import 'package:tayssir/features/notifications/data/remote_notification_data_source.dart';
import 'package:tayssir/features/notifications/domaine/notifiacation_model.dart';

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationsRepository(remoteDataSource: remoteDataSource);
});

class NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepository({
    required this.remoteDataSource,
  });

  Future<PaginatedData<NotificationModel>> getNotifications(
      {int page = 1}) async {
    try {
      final response = await remoteDataSource.getNotifications(page: page);
      final data = response.data['data']['notifications'] as List;
      final totalPages =
          response.data['data']['pagination']['last_page'] as int;
      final notifications = data
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
      // Add 10 test notifications for development
      // final testNotifications = [
      //   NotificationModel(
      //     id: '1',
      //     title: 'مرحباً بك في بيان!',
      //     body: 'شكراً لانضمامك إلى منصتنا. ابدأ بالتعرف على الميزات المتاحة.',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(minutes: 5)),
      //   ),
      //   NotificationModel(
      //     id: '2',
      //     title: 'رسالة جديدة واردة',
      //     body: 'لقد استلمت رسالة جديدة من مدرسك.',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(hours: 1)),
      //   ),
      //   NotificationModel(
      //     id: '3',
      //     title: 'تحديث الدورة',
      //     body: 'تمت إضافة مواد جديدة إلى الدورة المسجل بها.',
      //     isRead: true,
      //     time: DateTime.now().subtract(const Duration(hours: 3)),
      //   ),
      //   NotificationModel(
      //     id: '4',
      //     title: 'موعد تسليم الواجب قريب',
      //     body: 'موعد تسليم واجبك خلال يومين. لا تنس التسليم!',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(hours: 6)),
      //   ),
      //   NotificationModel(
      //     id: '5',
      //     title: 'تم نشر الدرجة',
      //     body: 'تم نشر درجتك للاختبار الأخير.',
      //     isRead: true,
      //     time: DateTime.now().subtract(const Duration(days: 1)),
      //   ),
      //   NotificationModel(
      //     id: '6',
      //     title: 'صيانة النظام',
      //     body: 'صيانة مجدولة ستحدث الليلة من الساعة 2-4 صباحاً.',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      //   ),
      //   NotificationModel(
      //     id: '7',
      //     title: 'ميزة جديدة متاحة',
      //     body: 'اطلع على ميزة منتدى النقاش الجديدة المتاحة الآن!',
      //     isRead: true,
      //     time: DateTime.now().subtract(const Duration(days: 2)),
      //   ),
      //   NotificationModel(
      //     id: '8',
      //     title: 'تذكير بالدفع',
      //     body: 'موعد دفع اشتراكك الأسبوع القادم.',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(days: 3)),
      //   ),
      //   NotificationModel(
      //     id: '9',
      //     title: 'اكتمال الدورة',
      //     body: 'تهانينا! لقد أكملت دورتك بنجاح.',
      //     isRead: true,
      //     time: DateTime.now().subtract(const Duration(days: 5)),
      //   ),
      //   NotificationModel(
      //     id: '10',
      //     title: 'تقرير التقدم الأسبوعي',
      //     body: 'تقرير تقدمك في التعلم لهذا الأسبوع جاهز للمشاهدة.',
      //     isRead: false,
      //     time: DateTime.now().subtract(const Duration(days: 7)),
      //   ),
      // ];
      return PaginatedData<NotificationModel>(
        data: notifications,
        page: page,
        totalPages: totalPages,
      );
    } catch (e, st) {
      AppLogger.logError('Error fetching notifications: $e');
      rethrow;
    }
  }

  Future<void> markAsRead({required String id}) async {
    try {
      await remoteDataSource.markAsRead(id);
    } catch (e, st) {
      AppLogger.logError('Error marking notification as read: $e');
      rethrow;
    }
  }
}
