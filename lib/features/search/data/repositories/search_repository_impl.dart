import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/domain/repositories/memory_repository.dart';
import '../../domain/entities/search_filter.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/recent_searches_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required this.memoryRepository,
    required this.recentSearchesDataSource,
  });

  final MemoryRepository memoryRepository;
  final RecentSearchesDataSource recentSearchesDataSource;

  @override
  Future<List<Memory>> searchMemories({
    required String query,
    required SearchFilter filter,
  }) async {
    final allMemories = await memoryRepository.getAllMemories();
    final cleanQuery = query.trim().toLowerCase();

    // 1. Filter by criteria
    var filtered = allMemories.where((m) => filter.matches(m)).toList();

    // 2. Filter by search query if non-empty
    if (cleanQuery.isNotEmpty) {
      filtered = filtered.where((m) {
        // A. Title match
        if (m.title.toLowerCase().contains(cleanQuery)) return true;

        // B. Description match
        if (m.description != null &&
            m.description!.toLowerCase().contains(cleanQuery)) {
          return true;
        }

        // C. Location name or address
        if (m.location != null) {
          if (m.location!.name.toLowerCase().contains(cleanQuery)) return true;
          if (m.location!.address != null &&
              m.location!.address!.toLowerCase().contains(cleanQuery)) {
            return true;
          }
        }

        // D. Category match
        if (m.category.displayName.toLowerCase().contains(cleanQuery) ||
            m.category.name.toLowerCase().contains(cleanQuery)) {
          return true;
        }

        // E. Tags match
        for (final tag in m.tags) {
          if (tag.toLowerCase().contains(cleanQuery)) return true;
        }

        // F. Date formatted match
        final dateStr = '${m.date.day}/${m.date.month}/${m.date.year}';
        if (dateStr.contains(cleanQuery)) return true;

        return false;
      }).toList();
    }

    // 3. Sort results
    switch (filter.sortType) {
      case MemorySortType.newest:
        filtered.sort((a, b) => b.date.compareTo(a.date));
      case MemorySortType.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
      case MemorySortType.alphabetical:
        filtered.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }

    return filtered;
  }

  @override
  Future<List<SearchSuggestion>> getSuggestions(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return const [];

    final allMemories = await memoryRepository.getAllMemories();
    final List<SearchSuggestion> suggestions = [];
    final Set<String> seen = {};

    // 1. Matching Categories
    for (final cat in MemoryCategory.values) {
      if (cat.displayName.toLowerCase().contains(cleanQuery) ||
          cat.name.toLowerCase().contains(cleanQuery)) {
        if (seen.add('cat_${cat.name}')) {
          suggestions.add(
            SearchSuggestion(
              text: cat.displayName,
              type: SearchSuggestionType.category,
              subtitle: 'Category',
            ),
          );
        }
      }
    }

    // 2. Matching Locations
    for (final m in allMemories) {
      if (m.location != null && m.location!.name.trim().isNotEmpty) {
        final locName = m.location!.name.trim();
        if (locName.toLowerCase().contains(cleanQuery)) {
          if (seen.add('loc_${locName.toLowerCase()}')) {
            suggestions.add(
              SearchSuggestion(
                text: locName,
                type: SearchSuggestionType.location,
                subtitle: m.location!.address,
              ),
            );
          }
        }
      }
    }

    // 3. Matching Tags
    for (final m in allMemories) {
      for (final tag in m.tags) {
        if (tag.toLowerCase().contains(cleanQuery)) {
          if (seen.add('tag_${tag.toLowerCase()}')) {
            suggestions.add(
              SearchSuggestion(
                text: tag,
                type: SearchSuggestionType.tag,
                subtitle: 'Tag',
              ),
            );
          }
        }
      }
    }

    // 4. Matching Titles
    for (final m in allMemories) {
      if (m.title.toLowerCase().contains(cleanQuery)) {
        if (seen.add('title_${m.title.toLowerCase()}')) {
          suggestions.add(
            SearchSuggestion(
              text: m.title,
              type: SearchSuggestionType.title,
              subtitle: 'Memory Title',
            ),
          );
        }
      }
    }

    // Limit to top 8 suggestions
    return suggestions.take(8).toList();
  }

  @override
  Future<List<String>> getRecentSearches() {
    return recentSearchesDataSource.getRecentSearches();
  }

  @override
  Future<void> saveRecentSearch(String query) {
    return recentSearchesDataSource.addRecentSearch(query);
  }

  @override
  Future<void> removeRecentSearch(String query) {
    return recentSearchesDataSource.removeRecentSearch(query);
  }

  @override
  Future<void> clearRecentSearches() {
    return recentSearchesDataSource.clearRecentSearches();
  }
}

