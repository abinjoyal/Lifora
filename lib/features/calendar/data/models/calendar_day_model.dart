import '../../domain/entities/calendar_day.dart';

class CalendarDayModel extends CalendarDay {
  const CalendarDayModel({
    required super.date,
    required super.isCurrentMonth,
    super.isToday = false,
    super.isSelected = false,
    super.memories = const [],
  });

  factory CalendarDayModel.fromEntity(CalendarDay entity) {
    return CalendarDayModel(
      date: entity.date,
      isCurrentMonth: entity.isCurrentMonth,
      isToday: entity.isToday,
      isSelected: entity.isSelected,
      memories: entity.memories,
    );
  }
}

