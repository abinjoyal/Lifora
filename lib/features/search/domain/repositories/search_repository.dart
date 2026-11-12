import '../../../memories/domain/entities/memory.dart';
import '../entities/search_filter.dart';
import '../entities/search_suggestion.dart';

abstract class SearchRepository {
  Future<List<Memory>> searchMemories({
    required String query,
    required SearchFilter filter,
  });

  Future<List<SearchSuggestion>> getSuggestions(String query);

  Future<List<String>> getRecentSearches();

  Future<void> saveRecentSearch(String query);

  Future<void> removeRecentSearch(String query);

  Future<void> clearRecentSearches();
}

