import 'package:flutter/material.dart';

class RecentSearchesView extends StatelessWidget {
  const RecentSearchesView({
    super.key,
    required this.recentSearches,
    required this.onSelectQuery,
    required this.onRemoveQuery,
    required this.onClearAll,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onSelectQuery;
  final ValueChanged<String> onRemoveQuery;
  final VoidCallback onClearAll;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _peach.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.manage_search_rounded,
                  size: 36,
                  color: _primaryOrange,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Find Any Memory Instantly',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _mainText,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search by title, description, location, category, tag or date.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _mainText,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: 13,
                    color: _primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            indent: 56,
            color: Color(0xFFF0E5DB),
          ),
          itemBuilder: (context, index) {
            final query = recentSearches[index];
            return ListTile(
              leading: const Icon(
                Icons.history_rounded,
                color: _secondaryText,
                size: 20,
              ),
              title: Text(
                query,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: _mainText,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: _secondaryText,
                ),
                onPressed: () => onRemoveQuery(query),
              ),
              onTap: () => onSelectQuery(query),
            );
          },
        ),
      ],
    );
  }
}

