import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../models/memory_model.dart';

abstract class MemoryIndexDataSource {
  Future<void> rebuildIndex(List<MemoryModel> memories);
  Future<List<MemoryModel>> queryMemories({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
    DateTime? date,
  });
  Future<void> indexMemory(MemoryModel memory);
  Future<void> removeIndexedMemory(String id);
}

class MemoryIndexDataSourceImpl implements MemoryIndexDataSource {
  MemoryIndexDataSourceImpl();

  final List<MemoryModel> _indexedMemories = [];

  @override
  Future<void> rebuildIndex(List<MemoryModel> memories) async {
    _indexedMemories.clear();
    _indexedMemories.addAll(memories);
  }

  @override
  Future<List<MemoryModel>> queryMemories({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
    DateTime? date,
  }) async {
    var result = List<MemoryModel>.from(_indexedMemories);

    // Filter by Category
    if (category != null) {
      result = result.where((m) => m.category == category).toList();
    }

    // Filter by Favorite
    if (isFavorite != null && isFavorite) {
      result = result.where((m) => m.isFavorite).toList();
    }

    // Filter by Date
    if (date != null) {
      result = result
          .where(
            (m) =>
                m.date.year == date.year &&
                m.date.month == date.month &&
                m.date.day == date.day,
          )
          .toList();
    }

    // Full text search in title, description, tags, and location
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((m) {
        final matchesTitle = m.title.toLowerCase().contains(q);
        final matchesDesc = m.description?.toLowerCase().contains(q) ?? false;
        final matchesLoc = m.location?.name.toLowerCase().contains(q) ?? false;
        final matchesTags = m.tags.any((t) => t.toLowerCase().contains(q));
        return matchesTitle || matchesDesc || matchesLoc || matchesTags;
      }).toList();
    }

    // Sort order
    switch (sortType) {
      case MemorySortType.newest:
        result.sort((a, b) => b.date.compareTo(a.date));
      case MemorySortType.oldest:
        result.sort((a, b) => a.date.compareTo(b.date));
      case MemorySortType.alphabetical:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }

    return result;
  }

  @override
  Future<void> indexMemory(MemoryModel memory) async {
    final index = _indexedMemories.indexWhere((m) => m.id == memory.id);
    if (index >= 0) {
      _indexedMemories[index] = memory;
    } else {
      _indexedMemories.add(memory);
    }
  }

  @override
  Future<void> removeIndexedMemory(String id) async {
    _indexedMemories.removeWhere((m) => m.id == id);
  }
}
