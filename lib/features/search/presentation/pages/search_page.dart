import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../../memories/presentation/widgets/memory_card.dart';
import '../../../memories/presentation/widgets/memory_list_item.dart';
import '../providers/search_provider.dart';
import '../widgets/recent_searches_view.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_filter_bottom_sheet.dart';
import '../widgets/search_input_field.dart';
import '../widgets/search_results_header.dart';
import '../widgets/search_suggestions_view.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchNotifierProvider);
    final searchNotifier = ref.read(searchNotifierProvider.notifier);
    final memoryListNotifier = ref.read(memoryListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Input Bar
            SearchInputField(
              initialQuery: searchState.query,
              onQueryChanged: searchNotifier.onQueryChanged,
              onSubmitted: searchNotifier.executeSearch,
              onBack: () => Navigator.pop(context),
            ),

            // 2. Loading Bar
            if (searchState.isLoading)
              const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
                minHeight: 2,
              ),

            // 3. Dynamic Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildBodyContent(
                  context,
                  ref,
                  searchState,
                  searchNotifier,
                  memoryListNotifier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
    SearchNotifier searchNotifier,
    dynamic memoryListNotifier,
  ) {
    // A. Show Recent Searches if query is empty and no active filters
    if (state.showRecents) {
      return RecentSearchesView(
        recentSearches: state.recentSearches,
        onSelectQuery: (query) {
          searchNotifier.executeSearch(query);
        },
        onRemoveQuery: searchNotifier.deleteRecentSearch,
        onClearAll: searchNotifier.deleteAllRecentSearches,
      );
    }

    // B. Show Live Suggestions if user is typing and not yet submitted
    if (state.showSuggestions) {
      return SearchSuggestionsView(
        suggestions: state.suggestions,
        onSelectSuggestion: (suggestion) {
          searchNotifier.executeSearch(suggestion.text);
        },
      );
    }

    // C. Search Results View
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchResultsHeader(
          resultCount: state.results.length,
          isGridView: state.isGridView,
          filter: state.filter,
          onToggleView: searchNotifier.toggleViewMode,
          onOpenFilter: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => SearchFilterBottomSheet(
                initialFilter: state.filter,
                onApply: searchNotifier.updateFilter,
              ),
            );
          },
        ),

        if (state.results.isEmpty && !state.isLoading)
          SearchEmptyState(
            hasActiveFilters: state.filter.hasActiveFilters,
            onClearFilters: searchNotifier.clearFilter,
          )
        else if (state.isGridView)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.78,
              ),
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final memory = state.results[index];
                return MemoryCard(
                  memory: memory,
                  onTap: () => _openDetails(context, memory),
                  onToggleFavorite: () =>
                      memoryListNotifier.toggleFavorite(memory.id),
                );
              },
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final memory = state.results[index];
              return MemoryListItem(
                memory: memory,
                onTap: () => _openDetails(context, memory),
                onToggleFavorite: () =>
                    memoryListNotifier.toggleFavorite(memory.id),
              );
            },
          ),
      ],
    );
  }

  void _openDetails(BuildContext context, Memory memory) {
    context.push(RouteConstants.memoryDetailsUrl(memory.id));
  }
}

