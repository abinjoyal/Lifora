class NotificationSettings {
  const NotificationSettings({
    this.enableAllNotifications = true,
    this.onThisDayEnabled = true,
    this.onThisDayHour = 9,
    this.onThisDayMinute = 0,
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    this.memorySavedConfirmation = true,
    this.privacyModeEnabled = false,
    this.customRemindersEnabled = true,
  });

  final bool enableAllNotifications;
  final bool onThisDayEnabled;
  final int onThisDayHour;
  final int onThisDayMinute;
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool memorySavedConfirmation;
  final bool privacyModeEnabled;
  final bool customRemindersEnabled;

  NotificationSettings copyWith({
    bool? enableAllNotifications,
    bool? onThisDayEnabled,
    int? onThisDayHour,
    int? onThisDayMinute,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? memorySavedConfirmation,
    bool? privacyModeEnabled,
    bool? customRemindersEnabled,
  }) {
    return NotificationSettings(
      enableAllNotifications:
          enableAllNotifications ?? this.enableAllNotifications,
      onThisDayEnabled: onThisDayEnabled ?? this.onThisDayEnabled,
      onThisDayHour: onThisDayHour ?? this.onThisDayHour,
      onThisDayMinute: onThisDayMinute ?? this.onThisDayMinute,
      dailyReminderEnabled:
          dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      memorySavedConfirmation:
          memorySavedConfirmation ?? this.memorySavedConfirmation,
      privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
      customRemindersEnabled:
          customRemindersEnabled ?? this.customRemindersEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettings &&
          runtimeType == other.runtimeType &&
          enableAllNotifications == other.enableAllNotifications &&
          onThisDayEnabled == other.onThisDayEnabled &&
          onThisDayHour == other.onThisDayHour &&
          onThisDayMinute == other.onThisDayMinute &&
          dailyReminderEnabled == other.dailyReminderEnabled &&
          dailyReminderHour == other.dailyReminderHour &&
          dailyReminderMinute == other.dailyReminderMinute &&
          memorySavedConfirmation == other.memorySavedConfirmation &&
          privacyModeEnabled == other.privacyModeEnabled &&
          customRemindersEnabled == other.customRemindersEnabled;

  @override
  int get hashCode =>
      enableAllNotifications.hashCode ^
      onThisDayEnabled.hashCode ^
      onThisDayHour.hashCode ^
      onThisDayMinute.hashCode ^
      dailyReminderEnabled.hashCode ^
      dailyReminderHour.hashCode ^
      dailyReminderMinute.hashCode ^
      memorySavedConfirmation.hashCode ^
      privacyModeEnabled.hashCode ^
      customRemindersEnabled.hashCode;
}

