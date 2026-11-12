import '../../../../shared/enums/memory_category.dart';
import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoriesByCategory {
  const GetMemoriesByCategory(this._repository);

  final MemoryRepository _repository;

  Future<List<Memory>> call(MemoryCategory category) {
    return _repository.getMemoriesByCategory(category);
  }
}
