import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class ToggleMemoryFavorite {
  const ToggleMemoryFavorite(this._repository);

  final MemoryRepository _repository;

  Future<Memory> call(String id) {
    return _repository.toggleFavorite(id);
  }
}
