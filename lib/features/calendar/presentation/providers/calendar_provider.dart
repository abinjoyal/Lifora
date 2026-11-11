import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/entities/calendar_stats.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/get_calendar_month.dart';
import '../../domain/usecases/get_calendar_stats.dart';
import '../../domain/usecases/get_calendar_year.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final memoryRepo = ref.watch(memoryRepositoryProvider);
  return CalendarRepositoryImpl(memoryRepository: memoryRepo);
});

final getCalendarMonthUseCaseProvider = Provider<GetCalendarMonth>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return GetCalendarMonth(repo);
});

final getCalendarYearUseCaseProvider = Provider<GetCalendarYear>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return GetCalendarYear(repo);
});

final getCalendarStatsUseCaseProvider = Provider<GetCalendarStats>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  return GetCalendarStats(repo);
});

class CalendarState {
  const CalendarState({
    required this.selectedDate,
    required this.viewYear,
    required this.viewMonth,
    this.days = const [],
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  final DateTime selectedDate;
  final int viewYear;
  final int viewMonth;
  final List<CalendarDay> days;
  final CalendarStats? stats;
  final bool isLoading;
  final String? errorMessage;

  List<Memory> get selectedDateMemories {
    for (final day in days) {
      if (day.date.year == selectedDate.year &&
          day.date.month == selectedDate.month &&
          day.date.day == selectedDate.day) {
        return day.memories;
      }
    }
    return const [];
  }

  CalendarDay? get selectedCalendarDay {
    for (final day in days) {
      if (day.date.year == selectedDate.year &&
          day.date.month == selectedDate.month &&
          day.date.day == selectedDate.day) {
        return day;
      }
    }
    return null;
  }

  CalendarState copyWith({
    DateTime? selectedDate,
    int? viewYear,
    int? viewMonth,
    List<CalendarDay>? days,
    CalendarStats? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      viewYear: viewYear ?? this.viewYear,
      viewMonth: viewMonth ?? this.viewMonth,
      days: days ?? this.days,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier({
    required this.getCalendarMonth,
    required this.getCalendarStats,
  }) : super(
          CalendarState(
            selectedDate: DateTime.now(),
            viewYear: DateTime.now().year,
            viewMonth: DateTime.now().month,
            isLoading: true,
          ),
        ) {
    loadCalendar(state.viewYear, state.viewMonth);
  }

  final GetCalendarMonth getCalendarMonth;
  final GetCalendarStats getCalendarStats;

  Future<void> loadCalendar(int year, int month) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final days = await getCalendarMonth(
        year: year,
        month: month,
        selectedDate: state.selectedDate,
      );
      final stats = await getCalendarStats(
        year: year,
        month: month,
      );

      state = state.copyWith(
        viewYear: year,
        viewMonth: month,
        days: days,
        stats: stats,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectDate(DateTime date) {
    if (date.year != state.viewYear || date.month != state.viewMonth) {
      state = state.copyWith(
        selectedDate: date,
        viewYear: date.year,
        viewMonth: date.month,
      );
      loadCalendar(date.year, date.month);
    } else {
      state = state.copyWith(selectedDate: date);
    }
  }

  void previousMonth() {
    var year = state.viewYear;
    var month = state.viewMonth - 1;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    loadCalendar(year, month);
  }

  void nextMonth() {
    var year = state.viewYear;
    var month = state.viewMonth + 1;
    if (month > 12) {
      month = 1;
      year += 1;
    }
    loadCalendar(year, month);
  }

  void jumpToToday() {
    final now = DateTime.now();
    state = state.copyWith(
      selectedDate: now,
      viewYear: now.year,
      viewMonth: now.month,
    );
    loadCalendar(now.year, now.month);
  }

  void changeYear(int year) {
    loadCalendar(year, state.viewMonth);
  }

  void refresh() {
    loadCalendar(state.viewYear, state.viewMonth);
  }
}

final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  // Watch memoryListNotifierProvider so whenever memories change, calendar auto-reloads
  ref.watch(memoryListNotifierProvider);

  final getMonth = ref.watch(getCalendarMonthUseCaseProvider);
  final getStats = ref.watch(getCalendarStatsUseCaseProvider);

  return CalendarNotifier(
    getCalendarMonth: getMonth,
    getCalendarStats: getStats,
  );
});
