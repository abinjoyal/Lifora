import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../domain/entities/memory.dart';
import 'memory_provider.dart';

class MemoryFilterState {
  const MemoryFilterState({
    this.category,
    this.sortType = MemorySortType.newest,
    this.isGridView = true,
    this.searchQuery = '',
    this.isFavoriteOnly = false,
  });

  final MemoryCategory? category;
  final MemorySortType sortType;
  final bool isGridView;
  final String searchQuery;
  final bool isFavoriteOnly;

  MemoryFilterState copyWith({
    MemoryCategory? Function()? category,
    MemorySortType? sortType,
    bool? isGridView,
    String? searchQuery,
    bool? isFavoriteOnly,
  }) {
    return MemoryFilterState(
      category: category != null ? category() : this.category,
      sortType: sortType ?? this.sortType,
      isGridView: isGridView ?? this.isGridView,
      searchQuery: searchQuery ?? this.searchQuery,
      isFavoriteOnly: isFavoriteOnly ?? this.isFavoriteOnly,
    );
  }
}

class MemoryFilterNotifier extends StateNotifier<MemoryFilterState> {
  MemoryFilterNotifier() : super(const MemoryFilterState());

  void setCategory(MemoryCategory? category) {
    state = state.copyWith(category: () => category);
  }

  void setSortType(MemorySortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void toggleViewMode() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleFavoriteOnly() {
    state = state.copyWith(isFavoriteOnly: !state.isFavoriteOnly);
  }

  void clearFilters() {
    state = const MemoryFilterState();
  }
}

final memoryFilterProvider =
    StateNotifierProvider<MemoryFilterNotifier, MemoryFilterState>((ref) {
      return MemoryFilterNotifier();
    });

/// Computes dynamically filtered and sorted memory list in memory
final filteredMemoriesProvider = Provider<AsyncValue<List<Memory>>>((ref) {
  final memoriesAsync = ref.watch(memoryListNotifierProvider);
  final filter = ref.watch(memoryFilterProvider);

  return memoriesAsync.whenData((memories) {
    var result = List<Memory>.from(memories);

    // Category filter
    if (filter.category != null) {
      result = result.where((m) => m.category == filter.category).toList();
    }

    // Favorite filter
    if (filter.isFavoriteOnly) {
      result = result.where((m) => m.isFavorite).toList();
    }

    // Search query filter
    if (filter.searchQuery.trim().isNotEmpty) {
      final q = filter.searchQuery.toLowerCase().trim();
      result = result.where((m) {
        final matchTitle = m.title.toLowerCase().contains(q);
        final matchDesc = m.description?.toLowerCase().contains(q) ?? false;
        final matchLoc = m.location?.name.toLowerCase().contains(q) ?? false;
        final matchTags = m.tags.any((t) => t.toLowerCase().contains(q));
        return matchTitle || matchDesc || matchLoc || matchTags;
      }).toList();
    }

    // Sort order
    switch (filter.sortType) {
      case MemorySortType.newest:
        result.sort((a, b) => b.date.compareTo(a.date));
      case MemorySortType.oldest:
        result.sort((a, b) => a.date.compareTo(b.date));
      case MemorySortType.alphabetical:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }

    return result;
  });
});
