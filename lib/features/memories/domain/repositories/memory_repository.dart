import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../entities/memory.dart';

abstract class MemoryRepository {
  Future<List<Memory>> getAllMemories({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
  });

  Future<Memory?> getMemoryById(String id);

  Future<List<Memory>> getRecentMemories({int limit = 5});

  Future<List<Memory>> getMemoriesByDate(DateTime date);

  Future<List<Memory>> getMemoriesByCategory(MemoryCategory category);

  Future<Memory> createMemory(Memory memory, {List<String>? newPhotoPaths});

  Future<Memory> updateMemory(
    Memory memory, {
    List<String>? newPhotoPaths,
    List<String>? removedPhotoIds,
  });

  Future<void> deleteMemory(String id);

  Future<Memory> toggleFavorite(String id);

  Future<Map<String, int>> getMemoryStatistics();
}
