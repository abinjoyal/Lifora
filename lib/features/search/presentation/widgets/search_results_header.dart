import 'package:flutter/material.dart';
import '../../domain/entities/search_filter.dart';

class SearchResultsHeader extends StatelessWidget {
  const SearchResultsHeader({
    super.key,
    required this.resultCount,
    required this.isGridView,
    required this.filter,
    required this.onToggleView,
    required this.onOpenFilter,
  });

  final int resultCount;
  final bool isGridView;
  final SearchFilter filter;
  final VoidCallback onToggleView;
  final VoidCallback onOpenFilter;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Result count
          Text(
            resultCount == 1 ? '1 memory found' : '$resultCount memories found',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: _mainText,
            ),
          ),

          // Right: View toggle and Filter action
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isGridView
                      ? Icons.view_agenda_outlined
                      : Icons.grid_view_rounded,
                  color: _mainText,
                  size: 20,
                ),
                tooltip: isGridView ? 'List View' : 'Grid View',
                onPressed: onToggleView,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: filter.hasActiveFilters
                          ? _primaryOrange
                          : _mainText,
                      size: 20,
                    ),
                    tooltip: 'Filters',
                    onPressed: onOpenFilter,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  if (filter.hasActiveFilters)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: _primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${filter.activeFiltersCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
