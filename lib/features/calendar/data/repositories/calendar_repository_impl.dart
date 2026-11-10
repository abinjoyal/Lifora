import 'package:lifora/features/memories/domain/entities/memory.dart';
import 'package:lifora/features/memories/domain/repositories/memory_repository.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/entities/calendar_stats.dart';
import '../../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl({required this.memoryRepository});

  final MemoryRepository memoryRepository;

  @override
  Future<List<CalendarDay>> getCalendarMonth({
    required int year,
    required int month,
    DateTime? selectedDate,
  }) async {
    // 1. Fetch memories from existing memory repository
    final allMemories = await memoryRepository.getAllMemories();

    // 2. Index memories by local date key: "YYYY-M-D"
    final Map<String, List<Memory>> memoryMap = {};
    for (final m in allMemories) {
      final key = '${m.date.year}-${m.date.month}-${m.date.day}';
      memoryMap.putIfAbsent(key, () => []).add(m);
    }

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInCurrentMonth = DateTime(year, month + 1, 0).day;

    // Monday-based offset (Monday = 1 -> offset 0, Sunday = 7 -> offset 6)
    final leadingOffset = firstDayOfMonth.weekday - 1;

    final List<CalendarDay> calendarDays = [];

    // A. Trailing days from previous month
    if (leadingOffset > 0) {
      final prevMonthLastDay = DateTime(year, month, 0);
      final prevMonthDaysCount = prevMonthLastDay.day;
      for (int i = leadingOffset - 1; i >= 0; i--) {
        final d = prevMonthDaysCount - i;
        final date = DateTime(
          prevMonthLastDay.year,
          prevMonthLastDay.month,
          d,
        );
        final key = '${date.year}-${date.month}-${date.day}';
        final dayMemories = memoryMap[key] ?? const [];

        calendarDays.add(
          CalendarDay(
            date: date,
            isCurrentMonth: false,
            isToday: _isSameDay(date, now),
            isSelected: selectedDate != null && _isSameDay(date, selectedDate),
            memories: dayMemories,
          ),
        );
      }
    }

    // B. Current month days
    for (int day = 1; day <= daysInCurrentMonth; day++) {
      final date = DateTime(year, month, day);
      final key = '${date.year}-${date.month}-${date.day}';
      final dayMemories = memoryMap[key] ?? const [];

      calendarDays.add(
        CalendarDay(
          date: date,
          isCurrentMonth: true,
          isToday: _isSameDay(date, now),
          isSelected: selectedDate != null && _isSameDay(date, selectedDate),
          memories: dayMemories,
        ),
      );
    }

    // C. Leading days from next month to complete the 7-column grid
    final totalCells = (calendarDays.length / 7).ceil() * 7;
    final trailingNeeded = totalCells - calendarDays.length;
    for (int day = 1; day <= trailingNeeded; day++) {
      final nextMonth = month == 12 ? 1 : month + 1;
      final nextYear = month == 12 ? year + 1 : year;
      final date = DateTime(nextYear, nextMonth, day);
      final key = '${date.year}-${date.month}-${date.day}';
      final dayMemories = memoryMap[key] ?? const [];

      calendarDays.add(
        CalendarDay(
          date: date,
          isCurrentMonth: false,
          isToday: _isSameDay(date, now),
          isSelected: selectedDate != null && _isSameDay(date, selectedDate),
          memories: dayMemories,
        ),
      );
    }

    return calendarDays;
  }

  @override
  Future<Map<int, int>> getYearMemoryDistribution(int year) async {
    final allMemories = await memoryRepository.getAllMemories();
    final Map<int, int> distribution = {
      for (int m = 1; m <= 12; m++) m: 0,
    };

    for (final memory in allMemories) {
      if (memory.date.year == year) {
        distribution[memory.date.month] =
            (distribution[memory.date.month] ?? 0) + 1;
      }
    }

    return distribution;
  }

  @override
  Future<CalendarStats> getCalendarStats({
    required int year,
    required int month,
  }) async {
    final allMemories = await memoryRepository.getAllMemories();

    int monthCount = 0;
    int yearCount = 0;
    final Map<String, int> dateCounts = {};
    final Map<String, DateTime> dateObjects = {};

    for (final memory in allMemories) {
      if (memory.date.year == year) {
        yearCount++;
        if (memory.date.month == month) {
          monthCount++;
        }
      }

      final key = '${memory.date.year}-${memory.date.month}-${memory.date.day}';
      dateCounts[key] = (dateCounts[key] ?? 0) + 1;
      dateObjects[key] =
          DateTime(memory.date.year, memory.date.month, memory.date.day);
    }

    DateTime? peakDate;
    int maxCount = 0;

    dateCounts.forEach((key, count) {
      if (count > maxCount) {
        maxCount = count;
        peakDate = dateObjects[key];
      }
    });

    return CalendarStats(
      monthMemoryCount: monthCount,
      yearMemoryCount: yearCount,
      totalMemories: allMemories.length,
      mostActiveDate: peakDate,
      mostActiveCount: maxCount,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
