import '../entities/calendar_day.dart';
import '../repositories/calendar_repository.dart';

class GetCalendarMonth {
  GetCalendarMonth(this._repository);

  final CalendarRepository _repository;

  Future<List<CalendarDay>> call({
    required int year,
    required int month,
    DateTime? selectedDate,
  }) {
    return _repository.getCalendarMonth(
      year: year,
      month: month,
      selectedDate: selectedDate,
    );
  }
}

