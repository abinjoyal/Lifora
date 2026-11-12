import 'package:flutter/material.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import 'memories_category_filter.dart';

class MemoriesFilterBar extends StatelessWidget {
  const MemoriesFilterBar({
    super.key,
    required this.selectedCategory,
    required this.sortType,
    required this.isFavoriteOnly,
    required this.onSelectCategory,
    required this.onSelectSortType,
    required this.onToggleFavoriteOnly,
  });

  final MemoryCategory? selectedCategory;
  final MemorySortType sortType;
  final bool isFavoriteOnly;
  final ValueChanged<MemoryCategory?> onSelectCategory;
  final ValueChanged<MemorySortType> onSelectSortType;
  final VoidCallback onToggleFavoriteOnly;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _iconColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Pills
        MemoriesCategoryFilter(
          selectedCategory: selectedCategory,
          onSelectCategory: onSelectCategory,
        ),
        const SizedBox(height: 10.0),

        // Controls bar: Sort + Favorites Toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sort Selector
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () => _showSortModal(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 6.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sort_rounded,
                        color: _iconColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        sortType.displayName,
                        style: const TextStyle(
                          color: _iconColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: _iconColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite Filter Chip
              InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: onToggleFavoriteOnly,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: isFavoriteOnly
                        ? const Color(0xFFFFEBEE)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isFavoriteOnly
                          ? const Color(0xFFE91E63)
                          : const Color(0xFFEADBCE),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFavoriteOnly
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        size: 15.0,
                        color: isFavoriteOnly
                            ? const Color(0xFFE91E63)
                            : _iconColor,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Favorites',
                        style: TextStyle(
                          color: isFavoriteOnly
                              ? const Color(0xFFE91E63)
                              : _iconColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort Memories By',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF38251F),
                  ),
                ),
                const SizedBox(height: 14.0),
                ...MemorySortType.values.map((type) {
                  final isSelected = type == sortType;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      type.displayName,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? _primaryOrange
                            : const Color(0xFF38251F),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded, color: _primaryOrange)
                        : null,
                    onTap: () {
                      onSelectSortType(type);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
