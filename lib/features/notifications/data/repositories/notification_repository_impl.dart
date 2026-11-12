import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../memories/domain/repositories/memory_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/memory_reminder.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_service.dart';
import '../datasources/notification_storage_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.localService,
    required this.storageDataSource,
    required this.memoryRepository,
  });

  final NotificationLocalService localService;
  final NotificationStorageDataSource storageDataSource;
  final MemoryRepository memoryRepository;

  static const int _dailyReminderNotificationId = 888001;
  static const int _onThisDayNotificationId = 888002;

  @override
  Future<List<AppNotification>> getInboxNotifications() async {
    final list = await storageDataSource.getInboxNotifications();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    final list = await storageDataSource.getInboxNotifications();
    return list.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    final list = await storageDataSource.getInboxNotifications();
    final index = list.indexWhere((n) => n.id == id);
    if (index >= 0) {
      list[index] = list[index].copyWith(isRead: true);
      await storageDataSource.saveInboxNotifications(list);
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    final list = await storageDataSource.getInboxNotifications();
    final updated = list.map((n) => n.copyWith(isRead: true)).toList();
    await storageDataSource.saveInboxNotifications(updated);
  }

  @override
  Future<void> deleteNotification(String id) async {
    final list = await storageDataSource.getInboxNotifications();
    list.removeWhere((n) => n.id == id);
    await storageDataSource.saveInboxNotifications(list);
  }

  @override
  Future<void> clearAllNotifications() async {
    await storageDataSource.saveInboxNotifications([]);
  }

  @override
  Future<void> addInboxNotification(AppNotification notification) async {
    final list = await storageDataSource.getInboxNotifications();
    list.insert(0, notification);
    await storageDataSource.saveInboxNotifications(list);
  }

  @override
  Future<List<MemoryReminder>> getReminders() async {
    final list = await storageDataSource.getReminders();
    list.sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
    return list;
  }

  @override
  Future<void> saveReminder(MemoryReminder reminder) async {
    final list = await storageDataSource.getReminders();
    final index = list.indexWhere((r) => r.id == reminder.id);
    if (index >= 0) {
      list[index] = reminder;
    } else {
      list.add(reminder);
    }
    await storageDataSource.saveReminders(list);

    // Schedule or cancel local notification
    final notifId = reminder.id.hashCode & 0x7FFFFFFF;
    if (reminder.isEnabled) {
      final settings = await getSettings();
      if (settings.enableAllNotifications && settings.customRemindersEnabled) {
        final title = settings.privacyModeEnabled
            ? 'Memory Reminder'
            : reminder.title;
        final body = settings.privacyModeEnabled
            ? 'You have a scheduled memory reminder.'
            : (reminder.description?.isNotEmpty == true
                ? reminder.description!
                : 'Take a moment to revisit this memory.');

        DateTimeComponents? matchComponents;
        switch (reminder.repeatType) {
          case ReminderRepeatType.daily:
            matchComponents = DateTimeComponents.time;
          case ReminderRepeatType.weekly:
            matchComponents = DateTimeComponents.dayOfWeekAndTime;
          case ReminderRepeatType.monthly:
            matchComponents = DateTimeComponents.dayOfMonthAndTime;
          case ReminderRepeatType.yearly:
            matchComponents = DateTimeComponents.dateAndTime;
          case ReminderRepeatType.never:
            matchComponents = null;
        }

        await localService.scheduleNotification(
          id: notifId,
          title: title,
          body: body,
          scheduledDate: reminder.scheduledDateTime,
          payload: reminder.linkedMemoryId,
          channelId: NotificationLocalService.channelReminders,
          matchDateTimeComponents: matchComponents,
        );
      }
    } else {
      await localService.cancelNotification(notifId);
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    final notifId = id.hashCode & 0x7FFFFFFF;
    await localService.cancelNotification(notifId);

    final list = await storageDataSource.getReminders();
    list.removeWhere((r) => r.id == id);
    await storageDataSource.saveReminders(list);
  }

  @override
  Future<void> toggleReminder(String id, bool isEnabled) async {
    final list = await storageDataSource.getReminders();
    final index = list.indexWhere((r) => r.id == id);
    if (index >= 0) {
      final updated = list[index].copyWith(
        isEnabled: isEnabled,
        updatedAt: DateTime.now(),
      );
      await saveReminder(updated);
    }
  }

  @override
  Future<NotificationSettings> getSettings() async {
    return storageDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(NotificationSettings settings) async {
    await storageDataSource.saveSettings(settings);
    await rescheduleAllNotifications();
  }

  @override
  Future<bool> checkPermission() {
    return localService.checkPermission();
  }

  @override
  Future<bool> requestPermission() {
    return localService.requestPermission();
  }

  @override
  Future<void> checkAndScheduleOnThisDay() async {
    final settings = await getSettings();
    if (!settings.enableAllNotifications || !settings.onThisDayEnabled) {
      await localService.cancelNotification(_onThisDayNotificationId);
      return;
    }

    final now = DateTime.now();
    final allMemories = await memoryRepository.getAllMemories();

    // Find memories on this day in past years
    final matching = allMemories.where((m) {
      final isPastYear = m.date.year < now.year;
      final isSameMonthAndDay =
          m.date.month == now.month && m.date.day == now.day;

      // Handle leap year Feb 29 on non-leap years
      final isLeapFeb29OnNonLeapYear = now.month == 2 &&
          now.day == 28 &&
          !_isLeapYear(now.year) &&
          m.date.month == 2 &&
          m.date.day == 29;

      return isPastYear && (isSameMonthAndDay || isLeapFeb29OnNonLeapYear);
    }).toList();

    if (matching.isNotEmpty) {
      final first = matching.first;
      final yearsAgo = now.year - first.date.year;
      final yearText = yearsAgo == 1 ? '1 year ago' : '$yearsAgo years ago';

      final title = settings.privacyModeEnabled
          ? 'On This Day in Lifora'
          : (matching.length == 1
              ? 'On This Day: ${first.title}'
              : 'On This Day ($yearText)');

      final body = settings.privacyModeEnabled
          ? 'You have memories saved on this day in previous years.'
          : (matching.length == 1
              ? 'Take a moment to revisit what happened $yearText today.'
              : 'You have ${matching.length} memories recorded on this day.');

      // Schedule at user's preferred On This Day time
      var scheduleTime = DateTime(
        now.year,
        now.month,
        now.day,
        settings.onThisDayHour,
        settings.onThisDayMinute,
      );

      // If scheduled time has already passed today, display or record inbox entry
      if (now.isAfter(scheduleTime)) {
        // Add inbox record if not already recorded today
        final inbox = await storageDataSource.getInboxNotifications();
        final alreadyLogged = inbox.any(
          (n) =>
              n.type == AppNotificationType.onThisDay &&
              n.createdAt.year == now.year &&
              n.createdAt.month == now.month &&
              n.createdAt.day == now.day,
        );

        if (!alreadyLogged) {
          await addInboxNotification(
            AppNotification(
              id: 'notif_otd_${now.millisecondsSinceEpoch}',
              title: title,
              body: body,
              type: AppNotificationType.onThisDay,
              linkedMemoryId: first.id,
              createdAt: now,
            ),
          );
        }
      } else {
        await localService.scheduleNotification(
          id: _onThisDayNotificationId,
          title: title,
          body: body,
          scheduledDate: scheduleTime,
          payload: first.id,
          channelId: NotificationLocalService.channelOnThisDay,
        );
      }
    }
  }

  @override
  Future<void> scheduleDailyReminder() async {
    final settings = await getSettings();
    if (!settings.enableAllNotifications || !settings.dailyReminderEnabled) {
      await localService.cancelNotification(_dailyReminderNotificationId);
      return;
    }

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      settings.dailyReminderHour,
      settings.dailyReminderMinute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await localService.scheduleNotification(
      id: _dailyReminderNotificationId,
      title: 'Make time for your memories',
      body: 'Take a minute to capture today\'s special moment in Lifora.',
      scheduledDate: scheduledDate,
      channelId: NotificationLocalService.channelDaily,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> showMemorySavedConfirmation(String memoryTitle) async {
    final settings = await getSettings();
    if (!settings.enableAllNotifications || !settings.memorySavedConfirmation) {
      return;
    }

    final title = settings.privacyModeEnabled
        ? 'Memory Saved'
        : 'Saved: $memoryTitle';
    const body = 'Your special moment has been safely preserved in your journal.';

    final notifId = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    await localService.showNotification(
      id: notifId,
      title: title,
      body: body,
      channelId: NotificationLocalService.channelSystem,
    );

    await addInboxNotification(
      AppNotification(
        id: 'notif_saved_$notifId',
        title: title,
        body: body,
        type: AppNotificationType.memorySaved,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> rescheduleAllNotifications() async {
    await localService.cancelAllNotifications();

    final settings = await getSettings();
    if (!settings.enableAllNotifications) return;

    // 1. Reschedule Daily Reminder
    if (settings.dailyReminderEnabled) {
      await scheduleDailyReminder();
    }

    // 2. Reschedule On This Day
    if (settings.onThisDayEnabled) {
      await checkAndScheduleOnThisDay();
    }

    // 3. Reschedule active custom reminders
    if (settings.customRemindersEnabled) {
      final reminders = await getReminders();
      for (final r in reminders) {
        if (r.isEnabled && r.isUpcoming) {
          await saveReminder(r);
        }
      }
    }
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }
}

