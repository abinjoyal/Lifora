import '../models/memory_model.dart';

abstract class MemoryLocalDataSource {
  List<MemoryModel> getCachedMemories();
  MemoryModel? getCachedMemory(String id);
  void cacheMemories(List<MemoryModel> memories);
  void upsertMemory(MemoryModel memory);
  void removeMemory(String id);
  void clear();
}

class MemoryLocalDataSourceImpl implements MemoryLocalDataSource {
  MemoryLocalDataSourceImpl();

  final Map<String, MemoryModel> _cache = {};

  @override
  List<MemoryModel> getCachedMemories() => _cache.values.toList();

  @override
  MemoryModel? getCachedMemory(String id) => _cache[id];

  @override
  void cacheMemories(List<MemoryModel> memories) {
    _cache.clear();
    for (final m in memories) {
      _cache[m.id] = m;
    }
  }

  @override
  void upsertMemory(MemoryModel memory) {
    _cache[memory.id] = memory;
  }

  @override
  void removeMemory(String id) {
    _cache.remove(id);
  }

  @override
  void clear() {
    _cache.clear();
  }
}
