abstract class RecentSearchesDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> addRecentSearch(String query);
  Future<void> removeRecentSearch(String query);
  Future<void> clearRecentSearches();
}

class RecentSearchesDataSourceImpl implements RecentSearchesDataSource {
  RecentSearchesDataSourceImpl();

  static const int _maxRecentSearches = 10;
  static final List<String> _cachedHistory = [];

  @override
  Future<List<String>> getRecentSearches() async {
    return List<String>.from(_cachedHistory);
  }

  @override
  Future<void> addRecentSearch(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;

    // Remove if already exists so we can move it to the top
    _cachedHistory.removeWhere((item) => item.toLowerCase() == clean.toLowerCase());

    // Insert at front
    _cachedHistory.insert(0, clean);

    // Limit to max count
    if (_cachedHistory.length > _maxRecentSearches) {
      _cachedHistory.removeRange(_maxRecentSearches, _cachedHistory.length);
    }
  }

  @override
  Future<void> removeRecentSearch(String query) async {
    final clean = query.trim().toLowerCase();
    _cachedHistory.removeWhere((item) => item.toLowerCase() == clean);
  }

  @override
  Future<void> clearRecentSearches() async {
    _cachedHistory.clear();
  }
}

