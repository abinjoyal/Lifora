import 'package:lifora/features/memories/domain/entities/memory.dart';

class CalendarDay {
  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    this.isToday = false,
    this.isSelected = false,
    this.memories = const [],
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final List<Memory> memories;

  int get memoryCount => memories.length;
  bool get hasMemories => memories.isNotEmpty;
  bool get hasMultipleMemories => memories.length > 1;
  int get day => date.day;

  CalendarDay copyWith({
    DateTime? date,
    bool? isCurrentMonth,
    bool? isToday,
    bool? isSelected,
    List<Memory>? memories,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
      isToday: isToday ?? this.isToday,
      isSelected: isSelected ?? this.isSelected,
      memories: memories ?? this.memories,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDay &&
          runtimeType == other.runtimeType &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day &&
          isCurrentMonth == other.isCurrentMonth &&
          isSelected == other.isSelected &&
          memories.length == other.memories.length;

  @override
  int get hashCode =>
      date.year.hashCode ^
      date.month.hashCode ^
      date.day.hashCode ^
      isSelected.hashCode ^
      memories.length.hashCode;

  @override
  String toString() =>
      'CalendarDay(date: ${date.toIso8601String().substring(0, 10)}, count: $memoryCount)';
}

