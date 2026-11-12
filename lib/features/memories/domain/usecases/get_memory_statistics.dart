import '../repositories/memory_repository.dart';

class GetMemoryStatistics {
  const GetMemoryStatistics(this._repository);

  final MemoryRepository _repository;

  Future<Map<String, int>> call() {
    return _repository.getMemoryStatistics();
  }
}
