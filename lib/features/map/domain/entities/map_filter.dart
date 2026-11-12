import '../../../../shared/enums/memory_category.dart';
import '../../../memories/domain/entities/memory.dart';

enum MapDateFilterType {
  allTime,
  thisMonth,
  thisYear,
  customRange,
}

class MapFilter {
  const MapFilter({
    this.dateFilterType = MapDateFilterType.allTime,
    this.customStartDate,
    this.customEndDate,
    this.categories = const {},
    this.searchQuery = '',
  });

  final MapDateFilterType dateFilterType;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final Set<MemoryCategory> categories;
  final String searchQuery;

  bool get hasActiveFilters =>
      dateFilterType != MapDateFilterType.allTime ||
      categories.isNotEmpty ||
      searchQuery.trim().isNotEmpty;

  bool matches(Memory memory) {
    // 1. Must have valid coordinates
    if (memory.location?.hasCoordinates != true) {
      return false;
    }

    // 2. Category filter
    if (categories.isNotEmpty && !categories.contains(memory.category)) {
      return false;
    }

    // 3. Date filter
    final now = DateTime.now();
    switch (dateFilterType) {
      case MapDateFilterType.allTime:
        break;
      case MapDateFilterType.thisMonth:
        if (memory.date.year != now.year || memory.date.month != now.month) {
          return false;
        }
        break;
      case MapDateFilterType.thisYear:
        if (memory.date.year != now.year) {
          return false;
        }
        break;
      case MapDateFilterType.customRange:
        if (customStartDate != null && memory.date.isBefore(customStartDate!)) {
          return false;
        }
        if (customEndDate != null &&
            memory.date.isAfter(customEndDate!.add(const Duration(days: 1)))) {
          return false;
        }
        break;
    }

    // 4. Search query
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final titleMatch = memory.title.toLowerCase().contains(query);
      final descMatch =
          memory.description?.toLowerCase().contains(query) ?? false;
      final locNameMatch =
          memory.location?.name.toLowerCase().contains(query) ?? false;
      final addressMatch =
          memory.location?.address?.toLowerCase().contains(query) ?? false;

      if (!titleMatch && !descMatch && !locNameMatch && !addressMatch) {
        return false;
      }
    }

    return true;
  }

  MapFilter copyWith({
    MapDateFilterType? dateFilterType,
    DateTime? customStartDate,
    DateTime? customEndDate,
    Set<MemoryCategory>? categories,
    String? searchQuery,
  }) {
    return MapFilter(
      dateFilterType: dateFilterType ?? this.dateFilterType,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

