import '../../domain/entities/app_notification.dart';
import '../../domain/entities/memory_reminder.dart';
import '../../domain/entities/notification_settings.dart';

abstract class NotificationStorageDataSource {
  Future<List<AppNotification>> getInboxNotifications();
  Future<void> saveInboxNotifications(List<AppNotification> notifications);

  Future<List<MemoryReminder>> getReminders();
  Future<void> saveReminders(List<MemoryReminder> reminders);

  Future<NotificationSettings> getSettings();
  Future<void> saveSettings(NotificationSettings settings);
}

class NotificationStorageDataSourceImpl
    implements NotificationStorageDataSource {
  NotificationStorageDataSourceImpl();

  static final List<AppNotification> _inboxCache = [];
  static final List<MemoryReminder> _remindersCache = [];
  static NotificationSettings _settingsCache = const NotificationSettings();

  @override
  Future<List<AppNotification>> getInboxNotifications() async {
    return List<AppNotification>.from(_inboxCache);
  }

  @override
  Future<void> saveInboxNotifications(
      List<AppNotification> notifications) async {
    _inboxCache.clear();
    _inboxCache.addAll(notifications);
  }

  @override
  Future<List<MemoryReminder>> getReminders() async {
    return List<MemoryReminder>.from(_remindersCache);
  }

  @override
  Future<void> saveReminders(List<MemoryReminder> reminders) async {
    _remindersCache.clear();
    _remindersCache.addAll(reminders);
  }

  @override
  Future<NotificationSettings> getSettings() async {
    return _settingsCache;
  }

  @override
  Future<void> saveSettings(NotificationSettings settings) async {
    _settingsCache = settings;
  }
}

