import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  NotificationService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.lifora.app/notifications');

  final MethodChannel _channel;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Safely initializes notification channel and listeners.
  /// Does not crash if native notification plugins or services are not yet registered.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      final bool? success = await _channel.invokeMethod<bool>('initialize');
      _isInitialized = success ?? true;
      return _isInitialized;
    } on MissingPluginException {
      debugPrint(
        '[NotificationService] Native plugin not registered yet. Skipping safely.',
      );
      _isInitialized = false;
      return false;
    } on PlatformException catch (e) {
      debugPrint(
        '[NotificationService] PlatformException during initialization: ${e.message}',
      );
      _isInitialized = false;
      return false;
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Requests notification permission on Android 13+ (POST_NOTIFICATIONS).
  Future<bool> requestNotificationPermission() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>(
        'requestPermission',
      );
      return granted ?? false;
    } on MissingPluginException {
      debugPrint('[NotificationService] Notification plugin not registered.');
      return false;
    } catch (e) {
      debugPrint('[NotificationService] Permission request failed: $e');
      return false;
    }
  }

  /// Schedules daily memory reminder if permitted.
  Future<bool> scheduleDailyMemoryReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) {
      final initOk = await initialize();
      if (!initOk) return false;
    }

    try {
      final bool? scheduled = await _channel.invokeMethod<bool>(
        'scheduleReminder',
        {'hour': hour, 'minute': minute, 'title': title, 'body': body},
      );
      return scheduled ?? false;
    } catch (e) {
      debugPrint('[NotificationService] Failed to schedule reminder: $e');
      return false;
    }
  }

  /// Cancels all scheduled reminders.
  Future<void> cancelAllReminders() async {
    try {
      await _channel.invokeMethod<void>('cancelAll');
    } catch (e) {
      debugPrint('[NotificationService] Failed to cancel notifications: $e');
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
