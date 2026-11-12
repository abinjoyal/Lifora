import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetAllMemories {
  const GetAllMemories(this._repository);

  final MemoryRepository _repository;

  Future<List<Memory>> call({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
  }) {
    return _repository.getAllMemories(
      category: category,
      sortType: sortType,
      isFavorite: isFavorite,
      query: query,
    );
  }
}
