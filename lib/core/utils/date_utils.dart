import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _isoFormat = DateFormat(
    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
  );
  static final DateFormat _readableFormat = DateFormat('MMMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _dayOfWeekFormat = DateFormat('EEEE');
  static final DateFormat _storageFolderFormat = DateFormat('yyyy_MM_dd');

  /// Formats date for display: "October 14, 2024"
  static String formatReadable(DateTime dateTime) {
    return _readableFormat.format(dateTime);
  }

  /// Formats time for display: "4:30 PM"
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Formats month and year: "October 2024"
  static String formatMonthYear(DateTime dateTime) {
    return _monthYearFormat.format(dateTime);
  }

  /// Formats day of the week: "Monday"
  static String formatDayOfWeek(DateTime dateTime) {
    return _dayOfWeekFormat.format(dateTime);
  }

  /// Formats date for storage folder naming: "2024_10_14"
  static String formatForStorageFolder(DateTime dateTime) {
    return _storageFolderFormat.format(dateTime);
  }

  /// Formats date to ISO8601 string for JSON persistence.
  static String formatIso8601(DateTime dateTime) {
    return _isoFormat.format(dateTime.toUtc());
  }

  /// Parses ISO8601 string safely, returning null on error.
  static DateTime? parseIso8601(String? isoString) {
    if (isoString == null || isoString.trim().isEmpty) return null;
    return DateTime.tryParse(isoString)?.toLocal();
  }

  /// Checks if two dates fall on the exact same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if date is today.
  static bool isToday(DateTime dateTime) {
    return isSameDay(dateTime, DateTime.now());
  }

  /// Checks if date is yesterday.
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(dateTime, yesterday);
  }

  /// Returns friendly relative date label ("Today", "Yesterday", or formatted date).
  static String formatRelative(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else if (isYesterday(dateTime)) {
      return 'Yesterday';
    }
    return formatReadable(dateTime);
  }

  /// Gets the start timestamp of a given date (00:00:00.000).
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end timestamp of a given date (23:59:59.999).
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Number of days in a given month.
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
