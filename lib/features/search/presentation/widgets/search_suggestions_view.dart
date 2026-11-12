import 'package:flutter/material.dart';
import '../../domain/entities/search_suggestion.dart';

class SearchSuggestionsView extends StatelessWidget {
  const SearchSuggestionsView({
    super.key,
    required this.suggestions,
    required this.onSelectSuggestion,
  });

  final List<SearchSuggestion> suggestions;
  final ValueChanged<SearchSuggestion> onSelectSuggestion;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _secondaryText,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            indent: 56,
            color: Color(0xFFF0E5DB),
          ),
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            final icon = _getIcon(suggestion.type);

            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _peach.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: _primaryOrange),
              ),
              title: Text(
                suggestion.text,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: _mainText,
                ),
              ),
              subtitle: suggestion.subtitle != null
                  ? Text(
                      suggestion.subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _secondaryText,
                      ),
                    )
                  : null,
              trailing: const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: _secondaryText,
              ),
              onTap: () => onSelectSuggestion(suggestion),
            );
          },
        ),
      ],
    );
  }

  IconData _getIcon(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.title:
        return Icons.auto_stories_rounded;
      case SearchSuggestionType.location:
        return Icons.location_on_rounded;
      case SearchSuggestionType.tag:
        return Icons.tag_rounded;
      case SearchSuggestionType.category:
        return Icons.category_rounded;
    }
  }
}

