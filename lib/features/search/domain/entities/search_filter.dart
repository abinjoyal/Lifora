import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../../memories/domain/entities/memory.dart';

enum SearchDateFilterType {
  allTime,
  today,
  thisWeek,
  thisMonth,
  thisYear,
  customRange,
}

enum SearchLocationFilterType {
  all,
  hasLocation,
  noLocation,
}

class SearchFilter {
  const SearchFilter({
    this.dateFilterType = SearchDateFilterType.allTime,
    this.customStartDate,
    this.customEndDate,
    this.categories = const {},
    this.locationFilterType = SearchLocationFilterType.all,
    this.isFavoriteOnly = false,
    this.sortType = MemorySortType.newest,
  });

  final SearchDateFilterType dateFilterType;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final Set<MemoryCategory> categories;
  final SearchLocationFilterType locationFilterType;
  final bool isFavoriteOnly;
  final MemorySortType sortType;

  bool get hasActiveFilters =>
      dateFilterType != SearchDateFilterType.allTime ||
      categories.isNotEmpty ||
      locationFilterType != SearchLocationFilterType.all ||
      isFavoriteOnly ||
      sortType != MemorySortType.newest;

  int get activeFiltersCount {
    int count = 0;
    if (dateFilterType != SearchDateFilterType.allTime) count++;
    if (categories.isNotEmpty) count += categories.length;
    if (locationFilterType != SearchLocationFilterType.all) count++;
    if (isFavoriteOnly) count++;
    if (sortType != MemorySortType.newest) count++;
    return count;
  }

  bool matches(Memory memory) {
    // 1. Favorites filter
    if (isFavoriteOnly && !memory.isFavorite) {
      return false;
    }

    // 2. Categories filter
    if (categories.isNotEmpty && !categories.contains(memory.category)) {
      return false;
    }

    // 3. Location filter
    switch (locationFilterType) {
      case SearchLocationFilterType.all:
        break;
      case SearchLocationFilterType.hasLocation:
        if (memory.location == null || memory.location!.name.trim().isEmpty) {
          return false;
        }
        break;
      case SearchLocationFilterType.noLocation:
        if (memory.location != null && memory.location!.name.trim().isNotEmpty) {
          return false;
        }
        break;
    }

    // 4. Date filter
    final now = DateTime.now();
    final memDate = memory.date;

    switch (dateFilterType) {
      case SearchDateFilterType.allTime:
        break;
      case SearchDateFilterType.today:
        if (memDate.year != now.year ||
            memDate.month != now.month ||
            memDate.day != now.day) {
          return false;
        }
        break;
      case SearchDateFilterType.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        if (memDate.isBefore(startOfDay)) {
          return false;
        }
        break;
      case SearchDateFilterType.thisMonth:
        if (memDate.year != now.year || memDate.month != now.month) {
          return false;
        }
        break;
      case SearchDateFilterType.thisYear:
        if (memDate.year != now.year) {
          return false;
        }
        break;
      case SearchDateFilterType.customRange:
        if (customStartDate != null) {
          final start = DateTime(
            customStartDate!.year,
            customStartDate!.month,
            customStartDate!.day,
          );
          if (memDate.isBefore(start)) return false;
        }
        if (customEndDate != null) {
          final end = DateTime(
            customEndDate!.year,
            customEndDate!.month,
            customEndDate!.day,
            23,
            59,
            59,
          );
          if (memDate.isAfter(end)) return false;
        }
        break;
    }

    return true;
  }

  SearchFilter copyWith({
    SearchDateFilterType? dateFilterType,
    DateTime? customStartDate,
    DateTime? customEndDate,
    Set<MemoryCategory>? categories,
    SearchLocationFilterType? locationFilterType,
    bool? isFavoriteOnly,
    MemorySortType? sortType,
  }) {
    return SearchFilter(
      dateFilterType: dateFilterType ?? this.dateFilterType,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      categories: categories ?? this.categories,
      locationFilterType: locationFilterType ?? this.locationFilterType,
      isFavoriteOnly: isFavoriteOnly ?? this.isFavoriteOnly,
      sortType: sortType ?? this.sortType,
    );
  }
}

