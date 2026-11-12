enum MemorySortType {
  newest,
  oldest,
  alphabetical;

  String get displayName {
    return switch (this) {
      MemorySortType.newest => 'Newest First',
      MemorySortType.oldest => 'Oldest First',
      MemorySortType.alphabetical => 'Alphabetical (A-Z)',
    };
  }
}
