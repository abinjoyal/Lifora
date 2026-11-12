import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_calendar_year.dart';
import 'calendar_provider.dart';

class CalendarYearState {
  const CalendarYearState({
    required this.year,
    this.monthCounts = const {},
    this.totalMemories = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final int year;
  final Map<int, int> monthCounts;
  final int totalMemories;
  final bool isLoading;
  final String? errorMessage;

  CalendarYearState copyWith({
    int? year,
    Map<int, int>? monthCounts,
    int? totalMemories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CalendarYearState(
      year: year ?? this.year,
      monthCounts: monthCounts ?? this.monthCounts,
      totalMemories: totalMemories ?? this.totalMemories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CalendarYearNotifier extends StateNotifier<CalendarYearState> {
  CalendarYearNotifier({
    required this.getCalendarYear,
    required int initialYear,
  }) : super(
          CalendarYearState(
            year: initialYear,
            isLoading: true,
          ),
        ) {
    loadYear(initialYear);
  }

  final GetCalendarYear getCalendarYear;

  Future<void> loadYear(int year) async {
    state = state.copyWith(year: year, isLoading: true, errorMessage: null);

    try {
      final counts = await getCalendarYear(year);
      final total = counts.values.fold<int>(0, (sum, count) => sum + count);
      state = state.copyWith(
        year: year,
        monthCounts: counts,
        totalMemories: total,
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

  void previousYear() {
    loadYear(state.year - 1);
  }

  void nextYear() {
    loadYear(state.year + 1);
  }
}

final calendarYearNotifierProvider = StateNotifierProvider.family<
    CalendarYearNotifier, CalendarYearState, int>((ref, year) {
  final getYearUseCase = ref.watch(getCalendarYearUseCaseProvider);
  return CalendarYearNotifier(
    getCalendarYear: getYearUseCase,
    initialYear: year,
  );
});
