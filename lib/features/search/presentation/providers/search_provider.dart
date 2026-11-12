import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../data/datasources/recent_searches_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_filter.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/clear_recent_searches.dart';
import '../../domain/usecases/get_recent_searches.dart';
import '../../domain/usecases/get_search_suggestions.dart';
import '../../domain/usecases/remove_recent_search.dart';
import '../../domain/usecases/save_recent_search.dart';
import '../../domain/usecases/search_memories.dart';

final recentSearchesDataSourceProvider =
    Provider<RecentSearchesDataSource>((ref) {
  return RecentSearchesDataSourceImpl();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final memoryRepo = ref.watch(memoryRepositoryProvider);
  final recentsSource = ref.watch(recentSearchesDataSourceProvider);
  return SearchRepositoryImpl(
    memoryRepository: memoryRepo,
    recentSearchesDataSource: recentsSource,
  );
});

final searchMemoriesUseCaseProvider = Provider<SearchMemories>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return SearchMemories(repo);
});

final getSearchSuggestionsUseCaseProvider =
    Provider<GetSearchSuggestions>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return GetSearchSuggestions(repo);
});

final getRecentSearchesUseCaseProvider = Provider<GetRecentSearches>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return GetRecentSearches(repo);
});

final saveRecentSearchUseCaseProvider = Provider<SaveRecentSearch>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return SaveRecentSearch(repo);
});

final removeRecentSearchUseCaseProvider = Provider<RemoveRecentSearch>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return RemoveRecentSearch(repo);
});

final clearRecentSearchesUseCaseProvider = Provider<ClearRecentSearches>((ref) {
  final repo = ref.watch(searchRepositoryProvider);
  return ClearRecentSearches(repo);
});

class SearchState {
  const SearchState({
    this.query = '',
    this.filter = const SearchFilter(),
    this.results = const [],
    this.suggestions = const [],
    this.recentSearches = const [],
    this.isGridView = true,
    this.isLoading = false,
    this.hasExecutedSearch = false,
    this.errorMessage,
  });

  final String query;
  final SearchFilter filter;
  final List<Memory> results;
  final List<SearchSuggestion> suggestions;
  final List<String> recentSearches;
  final bool isGridView;
  final bool isLoading;
  final bool hasExecutedSearch;
  final String? errorMessage;

  bool get isQueryEmpty => query.trim().isEmpty;
  bool get showRecents => isQueryEmpty && !hasExecutedSearch && !filter.hasActiveFilters;
  bool get showSuggestions => !isQueryEmpty && !hasExecutedSearch && suggestions.isNotEmpty;
  bool get showResults => hasExecutedSearch || filter.hasActiveFilters || !isQueryEmpty;

  SearchState copyWith({
    String? query,
    SearchFilter? filter,
    List<Memory>? results,
    List<SearchSuggestion>? suggestions,
    List<String>? recentSearches,
    bool? isGridView,
    bool? isLoading,
    bool? hasExecutedSearch,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      filter: filter ?? this.filter,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      isGridView: isGridView ?? this.isGridView,
      isLoading: isLoading ?? this.isLoading,
      hasExecutedSearch: hasExecutedSearch ?? this.hasExecutedSearch,
      errorMessage: errorMessage,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier({
    required this.searchMemories,
    required this.getSearchSuggestions,
    required this.getRecentSearches,
    required this.saveRecentSearch,
    required this.removeRecentSearch,
    required this.clearRecentSearches,
  }) : super(const SearchState()) {
    loadRecentSearches();
  }

  final SearchMemories searchMemories;
  final GetSearchSuggestions getSearchSuggestions;
  final GetRecentSearches getRecentSearches;
  final SaveRecentSearch saveRecentSearch;
  final RemoveRecentSearch removeRecentSearch;
  final ClearRecentSearches clearRecentSearches;

  Future<void> loadRecentSearches() async {
    final recents = await getRecentSearches();
    state = state.copyWith(recentSearches: recents);
  }

  Future<void> onQueryChanged(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      final recents = await getRecentSearches();
      state = state.copyWith(
        query: '',
        suggestions: const [],
        results: const [],
        recentSearches: recents,
        hasExecutedSearch: false,
      );
      return;
    }

    state = state.copyWith(query: query, isLoading: true);

    try {
      final suggestions = await getSearchSuggestions(clean);
      final results = await searchMemories(query: clean, filter: state.filter);
      state = state.copyWith(
        query: query,
        suggestions: suggestions,
        results: results,
        isLoading: false,
        hasExecutedSearch: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> executeSearch(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;

    state = state.copyWith(query: clean, isLoading: true);

    try {
      await saveRecentSearch(clean);
      final recents = await getRecentSearches();
      final results = await searchMemories(query: clean, filter: state.filter);

      state = state.copyWith(
        query: clean,
        results: results,
        recentSearches: recents,
        suggestions: const [],
        isLoading: false,
        hasExecutedSearch: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateFilter(SearchFilter filter) async {
    state = state.copyWith(filter: filter, isLoading: true);

    try {
      final results = await searchMemories(query: state.query, filter: filter);
      state = state.copyWith(
        filter: filter,
        results: results,
        isLoading: false,
        hasExecutedSearch: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> clearFilter() async {
    await updateFilter(const SearchFilter());
  }

  void toggleViewMode() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  Future<void> deleteRecentSearch(String query) async {
    await removeRecentSearch(query);
    final recents = await getRecentSearches();
    state = state.copyWith(recentSearches: recents);
  }

  Future<void> deleteAllRecentSearches() async {
    await clearRecentSearches();
    state = state.copyWith(recentSearches: const []);
  }
}

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  // Watch memoryListNotifierProvider so whenever memories change, search results update!
  ref.watch(memoryListNotifierProvider);

  final searchMem = ref.watch(searchMemoriesUseCaseProvider);
  final getSugg = ref.watch(getSearchSuggestionsUseCaseProvider);
  final getRecents = ref.watch(getRecentSearchesUseCaseProvider);
  final saveRec = ref.watch(saveRecentSearchUseCaseProvider);
  final remRec = ref.watch(removeRecentSearchUseCaseProvider);
  final clearRec = ref.watch(clearRecentSearchesUseCaseProvider);

  return SearchNotifier(
    searchMemories: searchMem,
    getSearchSuggestions: getSugg,
    getRecentSearches: getRecents,
    saveRecentSearch: saveRec,
    removeRecentSearch: remRec,
    clearRecentSearches: clearRec,
  );
});

