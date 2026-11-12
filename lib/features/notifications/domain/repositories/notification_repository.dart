import '../entities/app_notification.dart';
import '../entities/memory_reminder.dart';
import '../entities/notification_settings.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getInboxNotifications();

  Future<int> getUnreadNotificationCount();

  Future<void> markNotificationAsRead(String id);

  Future<void> markAllNotificationsAsRead();

  Future<void> deleteNotification(String id);

  Future<void> clearAllNotifications();

  Future<void> addInboxNotification(AppNotification notification);

  Future<List<MemoryReminder>> getReminders();

  Future<void> saveReminder(MemoryReminder reminder);

  Future<void> deleteReminder(String id);

  Future<void> toggleReminder(String id, bool isEnabled);

  Future<NotificationSettings> getSettings();

  Future<void> saveSettings(NotificationSettings settings);

  Future<bool> checkPermission();

  Future<bool> requestPermission();

  Future<void> checkAndScheduleOnThisDay();

  Future<void> scheduleDailyReminder();

  Future<void> showMemorySavedConfirmation(String memoryTitle);

  Future<void> rescheduleAllNotifications();
}

