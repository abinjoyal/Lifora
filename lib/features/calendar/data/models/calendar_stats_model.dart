import '../../domain/entities/calendar_stats.dart';

class CalendarStatsModel extends CalendarStats {
  const CalendarStatsModel({
    required super.monthMemoryCount,
    required super.yearMemoryCount,
    super.totalMemories = 0,
    super.mostActiveDate,
    super.mostActiveCount = 0,
  });

  factory CalendarStatsModel.fromEntity(CalendarStats entity) {
    return CalendarStatsModel(
      monthMemoryCount: entity.monthMemoryCount,
      yearMemoryCount: entity.yearMemoryCount,
      totalMemories: entity.totalMemories,
      mostActiveDate: entity.mostActiveDate,
      mostActiveCount: entity.mostActiveCount,
    );
  }
}
