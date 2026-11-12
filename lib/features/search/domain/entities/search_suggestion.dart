enum SearchSuggestionType {
  title,
  location,
  tag,
  category,
}

class SearchSuggestion {
  const SearchSuggestion({
    required this.text,
    required this.type,
    this.subtitle,
    this.count = 1,
  });

  final String text;
  final SearchSuggestionType type;
  final String? subtitle;
  final int count;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSuggestion &&
          runtimeType == other.runtimeType &&
          text.toLowerCase() == other.text.toLowerCase() &&
          type == other.type;

  @override
  int get hashCode => text.toLowerCase().hashCode ^ type.hashCode;
}

