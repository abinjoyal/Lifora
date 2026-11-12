import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetRecentMemories {
  const GetRecentMemories(this._repository);

  final MemoryRepository _repository;

  Future<List<Memory>> call({int limit = 5}) {
    return _repository.getRecentMemories(limit: limit);
  }
}
