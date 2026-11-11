class CalendarStats {
  const CalendarStats({
    required this.monthMemoryCount,
    required this.yearMemoryCount,
    this.totalMemories = 0,
    this.mostActiveDate,
    this.mostActiveCount = 0,
  });

  final int monthMemoryCount;
  final int yearMemoryCount;
  final int totalMemories;
  final DateTime? mostActiveDate;
  final int mostActiveCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarStats &&
          runtimeType == other.runtimeType &&
          monthMemoryCount == other.monthMemoryCount &&
          yearMemoryCount == other.yearMemoryCount &&
          totalMemories == other.totalMemories &&
          mostActiveDate == other.mostActiveDate &&
          mostActiveCount == other.mostActiveCount;

  @override
  int get hashCode =>
      monthMemoryCount.hashCode ^
      yearMemoryCount.hashCode ^
      totalMemories.hashCode ^
      mostActiveDate.hashCode ^
      mostActiveCount.hashCode;

  @override
  String toString() =>
      'CalendarStats(month: $monthMemoryCount, year: $yearMemoryCount, total: $totalMemories, mostActive: $mostActiveDate ($mostActiveCount))';
}
