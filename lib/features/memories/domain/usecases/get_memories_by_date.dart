import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoriesByDate {
  const GetMemoriesByDate(this._repository);

  final MemoryRepository _repository;

  Future<List<Memory>> call(DateTime date) {
    return _repository.getMemoriesByDate(date);
  }
}
