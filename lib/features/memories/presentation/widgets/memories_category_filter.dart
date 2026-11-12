import 'package:flutter/material.dart';
import '../../../../shared/enums/memory_category.dart';

class MemoriesCategoryFilter extends StatelessWidget {
  const MemoriesCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final MemoryCategory? selectedCategory;
  final ValueChanged<MemoryCategory?> onSelectCategory;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    final categories = [null, ...MemoryCategory.values];

    return SizedBox(
      height: 38.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final bool isSelected = selectedCategory == cat;
          final String label = cat == null ? 'All' : cat.displayName;

          return InkWell(
            borderRadius: BorderRadius.circular(20.0),
            onTap: () => onSelectCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected ? _primaryOrange : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: isSelected ? _primaryOrange : const Color(0xFFEADBCE),
                  width: 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _primaryOrange.withValues(alpha: 0.25),
                          blurRadius: 8.0,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cat != null) ...[
                    Icon(
                      cat.icon,
                      size: 14.0,
                      color: isSelected ? Colors.white : _primaryOrange,
                    ),
                    const SizedBox(width: 6.0),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _titleColor,
                      fontSize: 13.0,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
