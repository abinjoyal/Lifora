import '../repositories/calendar_repository.dart';

class GetCalendarYear {
  GetCalendarYear(this._repository);

  final CalendarRepository _repository;

  Future<Map<int, int>> call(int year) {
    return _repository.getYearMemoryDistribution(year);
  }
}

