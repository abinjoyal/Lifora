import '../entities/calendar_stats.dart';
import '../repositories/calendar_repository.dart';

class GetCalendarStats {
  GetCalendarStats(this._repository);

  final CalendarRepository _repository;

  Future<CalendarStats> call({
    required int year,
    required int month,
  }) {
    return _repository.getCalendarStats(year: year, month: month);
  }
}

