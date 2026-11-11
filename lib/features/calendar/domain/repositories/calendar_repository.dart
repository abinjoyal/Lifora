import '../entities/calendar_day.dart';
import '../entities/calendar_stats.dart';

abstract class CalendarRepository {
  /// Computes the complete 7-column calendar grid for a given year & month,
  /// including leading/trailing overflow days and actual attached memories.
  Future<List<CalendarDay>> getCalendarMonth({
    required int year,
    required int month,
    DateTime? selectedDate,
  });

  /// Returns memory counts grouped by month (1..12) for an annual overview.
  Future<Map<int, int>> getYearMemoryDistribution(int year);

  /// Computes monthly and yearly memory counts alongside the most active date.
  Future<CalendarStats> getCalendarStats({
    required int year,
    required int month,
  });
}

