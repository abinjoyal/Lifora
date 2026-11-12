import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../data/datasources/notification_local_service.dart';
import '../../data/datasources/notification_storage_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/check_and_schedule_on_this_day.dart';
import '../../domain/usecases/clear_inbox_notifications.dart';
import '../../domain/usecases/delete_inbox_notification.dart';
import '../../domain/usecases/delete_reminder.dart';
import '../../domain/usecases/get_inbox_notifications.dart';
import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/get_reminders.dart';
import '../../domain/usecases/mark_all_notifications_as_read.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/usecases/reschedule_all_notifications.dart';
import '../../domain/usecases/save_notification_settings.dart';
import '../../domain/usecases/save_reminder.dart';
import '../../domain/usecases/toggle_reminder_status.dart';

final notificationLocalServiceProvider =
    Provider<NotificationLocalService>((ref) {
  final service = NotificationLocalService();
  service.initialize();
  return service;
});

final notificationStorageDataSourceProvider =
    Provider<NotificationStorageDataSource>((ref) {
  return NotificationStorageDataSourceImpl();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final local = ref.watch(notificationLocalServiceProvider);
  final storage = ref.watch(notificationStorageDataSourceProvider);
  final memoryRepo = ref.watch(memoryRepositoryProvider);

  return NotificationRepositoryImpl(
    localService: local,
    storageDataSource: storage,
    memoryRepository: memoryRepo,
  );
});

final getInboxNotificationsUseCaseProvider =
    Provider<GetInboxNotifications>((ref) {
  return GetInboxNotifications(ref.watch(notificationRepositoryProvider));
});

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsRead>((ref) {
  return MarkNotificationAsRead(ref.watch(notificationRepositoryProvider));
});

final markAllNotificationsAsReadUseCaseProvider =
    Provider<MarkAllNotificationsAsRead>((ref) {
  return MarkAllNotificationsAsRead(ref.watch(notificationRepositoryProvider));
});

final deleteInboxNotificationUseCaseProvider =
    Provider<DeleteInboxNotification>((ref) {
  return DeleteInboxNotification(ref.watch(notificationRepositoryProvider));
});

final clearInboxNotificationsUseCaseProvider =
    Provider<ClearInboxNotifications>((ref) {
  return ClearInboxNotifications(ref.watch(notificationRepositoryProvider));
});

final getRemindersUseCaseProvider = Provider<GetReminders>((ref) {
  return GetReminders(ref.watch(notificationRepositoryProvider));
});

final saveReminderUseCaseProvider = Provider<SaveReminder>((ref) {
  return SaveReminder(ref.watch(notificationRepositoryProvider));
});

final deleteReminderUseCaseProvider = Provider<DeleteReminder>((ref) {
  return DeleteReminder(ref.watch(notificationRepositoryProvider));
});

final toggleReminderStatusUseCaseProvider =
    Provider<ToggleReminderStatus>((ref) {
  return ToggleReminderStatus(ref.watch(notificationRepositoryProvider));
});

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettings>((ref) {
  return GetNotificationSettings(ref.watch(notificationRepositoryProvider));
});

final saveNotificationSettingsUseCaseProvider =
    Provider<SaveNotificationSettings>((ref) {
  return SaveNotificationSettings(ref.watch(notificationRepositoryProvider));
});

final checkAndScheduleOnThisDayUseCaseProvider =
    Provider<CheckAndScheduleOnThisDay>((ref) {
  return CheckAndScheduleOnThisDay(ref.watch(notificationRepositoryProvider));
});

final rescheduleAllNotificationsUseCaseProvider =
    Provider<RescheduleAllNotifications>((ref) {
  return RescheduleAllNotifications(ref.watch(notificationRepositoryProvider));
});

class NotificationInboxState {
  const NotificationInboxState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => notifications.isEmpty && !isLoading;

  List<AppNotification> get todayNotifications {
    final now = DateTime.now();
    return notifications.where((n) {
      return n.createdAt.year == now.year &&
          n.createdAt.month == now.month &&
          n.createdAt.day == now.day;
    }).toList();
  }

  List<AppNotification> get yesterdayNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return notifications.where((n) {
      return n.createdAt.year == yesterday.year &&
          n.createdAt.month == yesterday.month &&
          n.createdAt.day == yesterday.day;
    }).toList();
  }

  List<AppNotification> get earlierNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final threshold = DateTime(yesterday.year, yesterday.month, yesterday.day);
    return notifications.where((n) {
      return n.createdAt.isBefore(threshold);
    }).toList();
  }

  NotificationInboxState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationInboxState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NotificationInboxNotifier extends StateNotifier<NotificationInboxState> {
  NotificationInboxNotifier({
    required this.getInbox,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.deleteUseCase,
    required this.clearAllUseCase,
    required this.checkOnThisDay,
  }) : super(const NotificationInboxState(isLoading: true)) {
    loadNotifications();
  }

  final GetInboxNotifications getInbox;
  final MarkNotificationAsRead markAsReadUseCase;
  final MarkAllNotificationsAsRead markAllAsReadUseCase;
  final DeleteInboxNotification deleteUseCase;
  final ClearInboxNotifications clearAllUseCase;
  final CheckAndScheduleOnThisDay checkOnThisDay;

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Check for On This Day notification triggers
      await checkOnThisDay();

      final list = await getInbox();
      final unread = list.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: list,
        unreadCount: unread,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await markAsReadUseCase(id);
      final list = state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final unread = list.where((n) => !n.isRead).length;
      state = state.copyWith(notifications: list, unreadCount: unread);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await markAllAsReadUseCase();
      final list =
          state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      state = state.copyWith(notifications: list, unreadCount: 0);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await deleteUseCase(id);
      final list = state.notifications.where((n) => n.id != id).toList();
      final unread = list.where((n) => !n.isRead).length;
      state = state.copyWith(notifications: list, unreadCount: unread);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> clearAll() async {
    try {
      await clearAllUseCase();
      state = state.copyWith(notifications: const [], unreadCount: 0);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final notificationInboxNotifierProvider =
    StateNotifierProvider<NotificationInboxNotifier, NotificationInboxState>(
        (ref) {
  final getInbox = ref.watch(getInboxNotificationsUseCaseProvider);
  final markRead = ref.watch(markNotificationAsReadUseCaseProvider);
  final markAllRead = ref.watch(markAllNotificationsAsReadUseCaseProvider);
  final delNotif = ref.watch(deleteInboxNotificationUseCaseProvider);
  final clearNotifs = ref.watch(clearInboxNotificationsUseCaseProvider);
  final checkOtd = ref.watch(checkAndScheduleOnThisDayUseCaseProvider);

  return NotificationInboxNotifier(
    getInbox: getInbox,
    markAsReadUseCase: markRead,
    markAllAsReadUseCase: markAllRead,
    deleteUseCase: delNotif,
    clearAllUseCase: clearNotifs,
    checkOnThisDay: checkOtd,
  );
});

