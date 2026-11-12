import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifora/features/memories/presentation/providers/memory_filter_provider.dart';
import 'package:lifora/features/memories/presentation/providers/memory_provider.dart';
import '../../../../core/constants/route_constants.dart';
import '../../domain/entities/memory.dart';
import '../widgets/memories_filter_bar.dart';
import '../widgets/memories_grid.dart';
import '../widgets/memories_header.dart';
import '../widgets/memories_list.dart';
import '../widgets/memory_empty_state.dart';

class MemoriesPage extends ConsumerWidget {
  const MemoriesPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMemoriesAsync = ref.watch(filteredMemoriesProvider);
    final filterState = ref.watch(memoryFilterProvider);
    final filterNotifier = ref.read(memoryFilterProvider.notifier);
    final listNotifier = ref.read(memoryListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            MemoriesHeader(
              isGridView: filterState.isGridView,
              onToggleView: () => filterNotifier.toggleViewMode(),
            ),

            // Category & Sort Filter Bar
            MemoriesFilterBar(
              selectedCategory: filterState.category,
              sortType: filterState.sortType,
              isFavoriteOnly: filterState.isFavoriteOnly,
              onSelectCategory: (cat) => filterNotifier.setCategory(cat),
              onSelectSortType: (sort) => filterNotifier.setSortType(sort),
              onToggleFavoriteOnly: () => filterNotifier.toggleFavoriteOnly(),
            ),
            const SizedBox(height: 6.0),

            // Gallery / List View Area
            Expanded(
              child: RefreshIndicator(
                color: _primaryOrange,
                backgroundColor: Colors.white,
                onRefresh: () => listNotifier.refresh(),
                child: filteredMemoriesAsync.when(
                  data: (memories) {
                    if (memories.isEmpty) {
                      return MemoryEmptyState(
                        title:
                            filterState.category != null ||
                                filterState.isFavoriteOnly
                            ? 'No Matching Memories'
                            : 'No Memories Yet',
                        message:
                            filterState.category != null ||
                                filterState.isFavoriteOnly
                            ? 'Try clearing your filters to see more memories.'
                            : 'Capture your first trip, event, or special moment in Lifora.',
                        onAddMemory: () =>
                            context.push(RouteConstants.createMemoryPath),
                      );
                    }

                    if (filterState.isGridView) {
                      return MemoriesGrid(
                        memories: memories,
                        onTapMemory: (m) => _navigateToDetails(context, m),
                        onToggleFavorite: (m) =>
                            listNotifier.toggleFavorite(m.id),
                      );
                    }

                    return MemoriesList(
                      memories: memories,
                      onTapMemory: (m) => _navigateToDetails(context, m),
                      onToggleFavorite: (m) =>
                          listNotifier.toggleFavorite(m.id),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.orange,
                          size: 44,
                        ),
                        const SizedBox(height: 10),
                        Text(e.toString()),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () => listNotifier.refresh(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        tooltip: 'Add Memory',
        onPressed: () => context.push(RouteConstants.createMemoryPath),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Memory memory) {
    context.push(RouteConstants.memoryDetailsUrl(memory.id));
  }
}
