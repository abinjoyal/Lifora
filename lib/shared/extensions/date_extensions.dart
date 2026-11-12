import '../../core/utils/date_utils.dart';

extension DateExtensions on DateTime {
  /// Formats date to user-readable string (e.g., "October 14, 2024").
  String toReadableDate() => AppDateUtils.formatReadable(this);

  /// Formats time to 12-hour format (e.g., "4:30 PM").
  String toReadableTime() => AppDateUtils.formatTime(this);

  /// Returns friendly relative date label ("Today", "Yesterday", or formatted date).
  String toRelativeLabel() => AppDateUtils.formatRelative(this);

  /// Month and year (e.g., "October 2024").
  String toMonthYear() => AppDateUtils.formatMonthYear(this);

  /// Day of week (e.g., "Monday").
  String toDayOfWeek() => AppDateUtils.formatDayOfWeek(this);

  /// Checks if this date falls on the exact same day as [other].
  bool isSameDayAs(DateTime other) => AppDateUtils.isSameDay(this, other);

  /// Checks if this date is today.
  bool get isToday => AppDateUtils.isToday(this);

  /// Checks if this date is yesterday.
  bool get isYesterday => AppDateUtils.isYesterday(this);

  /// Formats to ISO8601 string for persistence.
  String toIso8601() => AppDateUtils.formatIso8601(this);
}
